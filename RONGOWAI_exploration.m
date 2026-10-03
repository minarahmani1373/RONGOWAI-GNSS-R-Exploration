%% ============================================================
% RONGOWAI - Read and visualize all NetCDF files
%
% Variables:
%   sp_lat
%   sp_lon
%   surface_reflectivity_peak
%   ddm_snr
%
% Additional variables for land/ocean separation:
%   sp_surface_type
%   sp_dist_to_coast_km
%
% All valid observations from all files are combined.
%% ============================================================

clear;
clc;
close all;

%% ============================================================
% 1. Folder containing RONGOWAI NetCDF files
%% ============================================================

dataFolder = 'H:\rongowai';

files = dir(fullfile(dataFolder, '*.nc'));

fprintf('============================================\n');
fprintf('RONGOWAI DATA PROCESSING\n');
fprintf('============================================\n');

fprintf('Folder: %s\n', dataFolder);
fprintf('Number of NetCDF files found: %d\n\n', numel(files));

if isempty(files)
    error('No .nc files were found in H:\rongowai');
end


%% ============================================================
% 2. Initialize tables
%% ============================================================

allData = table();


%% ============================================================
% 3. Read all NetCDF files
%% ============================================================

for i = 1:numel(files)

    fileName = fullfile(files(i).folder, files(i).name);

    fprintf('Reading file %d/%d: %s\n', ...
        i, numel(files), files(i).name);

    %% --------------------------------------------------------
    % Read required variables
    %% --------------------------------------------------------

    lat  = ncread(fileName, 'sp_lat');
    lon  = ncread(fileName, 'sp_lon');

    refl = ncread(fileName, ...
        'surface_reflectivity_peak');

    snr  = ncread(fileName, 'ddm_snr');


    %% --------------------------------------------------------
    % Read variables for land/ocean classification
    %% --------------------------------------------------------

    surfaceType = ncread(fileName, ...
        'sp_surface_type');

    distCoast = ncread(fileName, ...
        'sp_dist_to_coast_km');


    %% --------------------------------------------------------
    % Convert everything to column vectors
    %% --------------------------------------------------------

    lat         = lat(:);
    lon         = lon(:);
    refl        = refl(:);
    snr         = snr(:);
    surfaceType = surfaceType(:);
    distCoast   = distCoast(:);


    %% --------------------------------------------------------
    % Remove invalid / NaN / Inf / fill values
    %% --------------------------------------------------------

    valid = isfinite(lat) & ...
            isfinite(lon) & ...
            isfinite(refl) & ...
            isfinite(snr) & ...
            isfinite(surfaceType) & ...
            isfinite(distCoast);


    % Geographic limits
    valid = valid & ...
            lat >= -90 & lat <= 90 & ...
            lon >= -180 & lon <= 180;


    % Remove common fill values
    valid = valid & ...
            lat ~= -99999999 & ...
            lon ~= -99999999 & ...
            refl ~= -99999999 & ...
            snr ~= -99999999;


    %% --------------------------------------------------------
    % Create table for this file
    %% --------------------------------------------------------

    T = table( ...
        lat(valid), ...
        lon(valid), ...
        refl(valid), ...
        snr(valid), ...
        surfaceType(valid), ...
        distCoast(valid), ...
        repmat(string(files(i).name), sum(valid), 1), ...
        'VariableNames', { ...
        'sp_lat', ...
        'sp_lon', ...
        'surface_reflectivity_peak', ...
        'ddm_snr', ...
        'sp_surface_type', ...
        'sp_dist_to_coast_km', ...
        'source_file'});


    %% --------------------------------------------------------
    % Add this file to the complete dataset
    %% --------------------------------------------------------

    allData = [allData; T];

end


%% ============================================================
% 4. Separate land and ocean
%% ============================================================

% According to RONGOWAI definition:
%
% Positive sp_dist_to_coast_km = land
% Negative sp_dist_to_coast_km = ocean

landMask  = allData.sp_dist_to_coast_km >= 0;
oceanMask = allData.sp_dist_to_coast_km < 0;


landData  = allData(landMask, :);
oceanData = allData(oceanMask, :);


%% ============================================================
% 5. Separate land surface types
%% ============================================================

% RONGOWAI surface type:
%
% -1 = ocean
%  1 = artificial
%  2 = barely vegetated
%  3 = inland water
%  4 = crop
%  5 = grass
%  6 = shrub
%  7 = forest


artificialData = landData( ...
    landData.sp_surface_type == 1, :);

barelyVegetatedData = landData( ...
    landData.sp_surface_type == 2, :);

inlandWaterData = landData( ...
    landData.sp_surface_type == 3, :);

cropData = landData( ...
    landData.sp_surface_type == 4, :);

grassData = landData( ...
    landData.sp_surface_type == 5, :);

shrubData = landData( ...
    landData.sp_surface_type == 6, :);

forestData = landData( ...
    landData.sp_surface_type == 7, :);


%% ============================================================
% 6. Soil-moisture relevant land dataset
%% ============================================================

% For now:
% Keep vegetated / potentially soil-moisture-relevant surfaces:
%
% crop + grass + shrub + forest

soilMoistureData = [
    cropData;
    grassData;
    shrubData;
    forestData
];


%% ============================================================
% 7. Print statistics
%% ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('DATA SUMMARY\n');
fprintf('============================================\n');

fprintf('Total valid observations : %d\n', ...
    height(allData));

fprintf('Land observations        : %d\n', ...
    height(landData));

fprintf('Ocean observations       : %d\n', ...
    height(oceanData));

fprintf('\n');

fprintf('Artificial               : %d\n', ...
    height(artificialData));

fprintf('Barely vegetated         : %d\n', ...
    height(barelyVegetatedData));

fprintf('Inland water             : %d\n', ...
    height(inlandWaterData));

fprintf('Crop                     : %d\n', ...
    height(cropData));

fprintf('Grass                    : %d\n', ...
    height(grassData));

fprintf('Shrub                    : %d\n', ...
    height(shrubData));

fprintf('Forest                   : %d\n', ...
    height(forestData));

fprintf('\n');

fprintf('Soil-moisture dataset    : %d\n', ...
    height(soilMoistureData));


%% ============================================================
% 8. Overall geographic range
%% ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('GEOGRAPHIC RANGE\n');
fprintf('============================================\n');

fprintf('Latitude : %.5f to %.5f deg\n', ...
    min(allData.sp_lat), ...
    max(allData.sp_lat));

fprintf('Longitude: %.5f to %.5f deg\n', ...
    min(allData.sp_lon), ...
    max(allData.sp_lon));


%% ============================================================
% 9. Reflectivity statistics
%% ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('REFLECTIVITY\n');
fprintf('============================================\n');

fprintf('Minimum : %.4f\n', ...
    min(allData.surface_reflectivity_peak));

fprintf('Maximum : %.4f\n', ...
    max(allData.surface_reflectivity_peak));

fprintf('Mean    : %.4f\n', ...
    mean(allData.surface_reflectivity_peak));

fprintf('Median  : %.4f\n', ...
    median(allData.surface_reflectivity_peak));


%% ============================================================
% 10. DDM SNR statistics
%% ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('DDM SNR\n');
fprintf('============================================\n');

fprintf('Minimum : %.4f dB\n', ...
    min(allData.ddm_snr));

fprintf('Maximum : %.4f dB\n', ...
    max(allData.ddm_snr));

fprintf('Mean    : %.4f dB\n', ...
    mean(allData.ddm_snr));

fprintf('Median  : %.4f dB\n', ...
    median(allData.ddm_snr));


%% ============================================================
% 11. MAP 1 - ALL observations
%     Color = surface reflectivity
%% ============================================================

figure('Color','w');

geoscatter( ...
    allData.sp_lat, ...
    allData.sp_lon, ...
    5, ...
    allData.surface_reflectivity_peak, ...
    'filled');

geobasemap satellite;

cb = colorbar;
cb.Label.String = ...
    'Peak Surface Reflectivity';

title('RONGOWAI - All Valid Observations');


%% ============================================================
% 12. MAP 2 - ALL observations
%     Color = DDM SNR
%% ============================================================

figure('Color','w');

geoscatter( ...
    allData.sp_lat, ...
    allData.sp_lon, ...
    5, ...
    allData.ddm_snr, ...
    'filled');

geobasemap satellite;

cb = colorbar;
cb.Label.String = 'DDM SNR (dB)';

title('RONGOWAI - All Observations: DDM SNR');


%% ============================================================
% 13. MAP 3 - LAND ONLY
%     Color = surface reflectivity
%% ============================================================

figure('Color','w');

geoscatter( ...
    landData.sp_lat, ...
    landData.sp_lon, ...
    5, ...
    landData.surface_reflectivity_peak, ...
    'filled');

geobasemap satellite;

cb = colorbar;
cb.Label.String = ...
    'Peak Surface Reflectivity';

title('RONGOWAI - Land Observations');


%% ============================================================
% 14. MAP 4 - SOIL-MOISTURE RELEVANT SURFACES
%% ============================================================

figure('Color','w');

geoscatter( ...
    soilMoistureData.sp_lat, ...
    soilMoistureData.sp_lon, ...
    5, ...
    soilMoistureData.surface_reflectivity_peak, ...
    'filled');

geobasemap satellite;

cb = colorbar;
cb.Label.String = ...
    'Peak Surface Reflectivity';

title('RONGOWAI - Vegetated Land Surfaces');


%% ============================================================
% 15. MAP 5 - Surface type
%% ============================================================

figure('Color','w');

geoscatter( ...
    landData.sp_lat, ...
    landData.sp_lon, ...
    5, ...
    landData.sp_surface_type, ...
    'filled');

geobasemap satellite;

cb = colorbar;

cb.Ticks = [1 2 3 4 5 6 7];

cb.TickLabels = { ...
    'Artificial', ...
    'Barely vegetated', ...
    'Inland water', ...
    'Crop', ...
    'Grass', ...
    'Shrub', ...
    'Forest'};

title('RONGOWAI - Land Surface Type');


%% ============================================================
% 16. Save all datasets
%% ============================================================

save(fullfile(dataFolder, ...
    'RONGOWAI_allData.mat'), ...
    'allData', '-v7.3');

save(fullfile(dataFolder, ...
    'RONGOWAI_landData.mat'), ...
    'landData', '-v7.3');

save(fullfile(dataFolder, ...
    'RONGOWAI_oceanData.mat'), ...
    'oceanData', '-v7.3');

save(fullfile(dataFolder, ...
    'RONGOWAI_soilMoistureData.mat'), ...
    'soilMoistureData', '-v7.3');

fprintf('\n');
fprintf('============================================\n');
fprintf('ALL DATASETS SAVED SUCCESSFULLY\n');
fprintf('============================================\n');