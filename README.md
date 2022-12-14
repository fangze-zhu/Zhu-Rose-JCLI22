# Zhu-Rose-JCLI22

This repository was developed for the paper:

**Zhu, F. and B.E.J. Rose. (2022). Multiple Equilibria in a Coupled Climate-Carbon Model. _Journal of Climate_. [DOI: 10.1175/JCLI-D-21-0984.1](https://doi.org/10.1175/JCLI-D-21-0984.1)**

## Cite this repository

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7438273.svg)](https://doi.org/10.5281/zenodo.7438273)

## Description

### 1. MITgcm version

checkpoint67f

### 2. Model configuration

- `pc.vars` specifies some parameters that replace those under `input_atm`, `input_ocn`, and `input_cpl`.
- `Run_model.sh` is an example bash script for submitting the job to run the model.

### 3. Scripts

- `EnergyBudget.ipynb` analyzes TOA energy balance, sea ice, surface temperature, atmospheric pCO<sub>2</sub>, and a bifurcation diagram.
- `Kernel.ipynb` calculates radiative kernels for Warm, Cold, and Waterbelt states.
- `FeedbacParameter.ipynb` calculates the globally averaged radiative feedback parameters, 9801 samples in total.
- `Histogram.ipynb` calculates the average on the 10th-90th percentiles of the 9801 samples of the radiatve feedbacks.
- `Spatial_feedback.ipynb` calculates the 3-D feedback parameters, 9801 samples in total.

### 4. Climatologies of multiple equilibria

- This folder contains data files for equilibrium Warm, Cold, and Waterbelt states, including pickup files.
- `Atm_available_diagnostics.log` and `Ocn_available_diagnostics.log` describe the available diagnostics in the model.

### 5. Radiative kernels

This folder contains the radiative kernels (output from `Kernel.ipynb`) for Warm, Cold and Waterbelt states. Up to five reference climates were selected to generate kernels for each state.


## Contact
fzhu@albany.edu
