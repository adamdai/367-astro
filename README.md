# 367-astro

This repository contains files for computational astrophotography deblurring.

## MATLAB
### final_writeup_script.m
This file executes the full deconvolution pipeline on an unblurred star image. It simulates a blurring effect around a given center location in the image, then maps the image to polar space and performs deconvolution with a linear blur kernel, then maps the image back to cartesian coordinates and applys brightness and contrast enhancement. The script has options for choosing the rotation center, deconvolution method, number of iterations, hyperparameters, regularization constants, and enhancement parameters.

### rotation_center_id.m
This file tests different methods for identifying the center of rotation of a star trail image. It contains options for least-squares fit, convex optimization implementation, and Hough transform method.

### real_star_trail_test.m
This file runs the full deblurring pipeline on a real star trail image. It uses the Hough transform to obtain the center of rotation then deconvolves the blur in the polar domain using ADMM with TV prior.  

These folders contain supplementary functions and scripts.

### circlefit
This folder contains different functions used to match circles to images or image coordinates for the purposen of determining star trail center of rotation.

### deconvolution_funcs
This folder contains functions for different deconvolution methods.

### utility
This folder contains miscellaneous utlity functions, such as mapping polar to/from cartesian, padding and unpadding the image, cropping away artifacts, normalization, contrast enhancement.

### testing
This folder contains miscellaneous scripts used during testing.

## Python


#### Adam Dai
addai@stanford.edu
#### David Whisler
dwhisler@stanford.edu
