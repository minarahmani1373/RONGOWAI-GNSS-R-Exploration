# RONGOWAI GNSS-R Data Exploration

Initial exploration and spatial analysis of airborne GNSS Reflectometry (GNSS-R) observations from the RONGOWAI L1 SDR dataset.

## Overview

This repository contains MATLAB code for the initial exploration and visualization of RONGOWAI GNSS-R observations.

The analysis focuses on:

- Specular point locations
- DDM Signal-to-Noise Ratio (SNR)

## Dataset

The analysis uses the RONGOWAI L1 SDR dataset.
http://search.earthdata.nasa.gov/search/granules?p=C2784494745-POCLOUD&pg[0][v]=f&pg[0][qt]=2022-05-11T00%3A00%3A00.000Z%2C2026-07-05T23%3A59%3A59.999Z&pg[0][gsk]=-start_date&g=G4227723100-POCLOUD&lat=-41.204&long=173.39088732394367&zoom=4.373764823736742

The original NetCDF (`.nc`) data files are not included in this repository.

## Main Variables

| Variable | Description |
|---|---|
| `sp_lat` | Specular point latitude |
| `sp_lon` | Specular point longitude |
| `ddm_snr` | DDM signal-to-noise ratio (dB) |


## Analysis Workflow

The observations are first explored spatially without applying soil-moisture-specific filtering.

For subsequent soil-moisture analysis, vegetated land observations are considered separately.

## Example Results

### DDM SNR

![DDM SNR](RONGOWAI_all_DDM_SNR.png)

## Tools

- MATLAB
- NetCDF
- GNSS Reflectometry (GNSS-R)

## Author

**Mina Rahmani**

PhD in Geodesy  
University of Naples Federico II
