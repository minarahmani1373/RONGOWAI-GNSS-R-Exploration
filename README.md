# RONGOWAI GNSS-R Data Exploration

Initial exploration and spatial analysis of airborne GNSS Reflectometry (GNSS-R) observations from the RONGOWAI L1 SDR dataset.

## Overview

This repository contains MATLAB code for the initial exploration and visualization of RONGOWAI GNSS-R observations.

The analysis focuses on:

- Specular point locations
- DDM Signal-to-Noise Ratio (SNR)

## Dataset

The analysis uses the RONGOWAI L1 SDR dataset.

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
