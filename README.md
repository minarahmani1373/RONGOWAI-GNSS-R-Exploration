# RONGOWAI GNSS-R Data Exploration

Initial exploration and spatial analysis of airborne GNSS Reflectometry (GNSS-R) observations from the RONGOWAI L1 SDR dataset.

## Overview

This repository contains MATLAB code for the initial exploration and visualization of RONGOWAI GNSS-R observations.

The analysis focuses on:

- Specular point locations
- DDM Signal-to-Noise Ratio (SNR)
- Surface reflectivity
- Land/ocean separation
- Surface-type classification
- Identification of observations relevant to soil-moisture analysis

## Dataset

The analysis uses the RONGOWAI L1 SDR dataset.

The original NetCDF (`.nc`) data files are not included in this repository.

## Main Variables

| Variable | Description |
|---|---|
| `sp_lat` | Specular point latitude |
| `sp_lon` | Specular point longitude |
| `ddm_snr` | DDM signal-to-noise ratio (dB) |
| `surface_reflectivity_peak` | Peak surface reflectivity |
| `sp_surface_type` | Surface type classification |
| `sp_dist_to_coast_km` | Distance from the coast |

## Analysis Workflow

The observations are first explored spatially without applying soil-moisture-specific filtering.

The observations are then separated into:

- All observations
- Land
- Ocean
- Artificial surfaces
- Barely vegetated surfaces
- Inland water
- Cropland
- Grassland
- Shrubland
- Forest

For subsequent soil-moisture analysis, vegetated land observations are considered separately.

## Example Results

### DDM SNR

![DDM SNR](RONGOWAI_all_DDM_SNR.png)

### Surface Reflectivity

![Surface Reflectivity](RONGOWAI_all_reflectivity.png)

### Land Surface Reflectivity

![Land Reflectivity](RONGOWAI_land_reflectivity.png)

### Vegetated Land

![Vegetated Land](RONGOWAI_soil_moisture_reflectivity.png)

### Surface Type

![Surface Type](RONGOWAI_surface_type.png)

## Tools

- MATLAB
- NetCDF
- GNSS Reflectometry (GNSS-R)

## Author

**Mina Rahmani**

PhD in Geodesy  
University of Naples Federico II
