# Simple Linear Regression Package
[![Build Status](https://travis-ci.org/hecro459/LinReg.svg?branch=master)](https://travis-ci.org/hecro459/LinReg)

R package with a simple implementation of Linear Regression using S3 classes. Ordinary Least-Squares and Bayesian estimation with non-informative prior are supported. 

The following functions are available:
* **linreg_ols**:  Fits a linear regression model using OLS and creates an lreg object
* **linreg_bayes**:  Fits a linear regression model using Bayesian estimation and creates an lreg object
* **print**:   Prints out the regression formula
* **coef**:    Returns the estimated coefficients
* **resid**:   Returns the residuals
* **pred**:    Returns the fitted values
* **plot**:    Plot simple regression diagnosis
* **summary**: Prints out summary of regression including p-values

## Setup
1. Download and install R from <http://www.r-project.org>
2. Download and install R Studio from <http://www.rstudio.com>
3. Run R Studio
4. Go to: *File* -> *New Project* -> *Version Control* -> *Git*
5. Introduce the link to the Github repo and setup local folders (see figure below). Click ok. If everything went smooth the repo was cloned and the new project is automatically loaded.

<p align="left">
   <img src="https://raw.githubusercontent.com/hecro459/LinReg/master/setup01.png" width="400">

6. Go to: *Build* -> *Configure build tools* and  enter the information as shown in the figure below. Check all Roxygen options inside *Configure*. Click ok.

<p align="left">
   <img src="https://raw.githubusercontent.com/hecro459/LinReg/master/setup02.png" width="400">
   
7. Now run: *Build* -> *Clean and Rebuild*. The package should be built and loaded. Now you can access the functions from the package. 

## Example
```r
y <- c(AirPassengers)
D = data.frame(x=seq(1,length(y)),y=y)
f <- y~x
lreg <- linreg(D,f,0) #OLS Estimation
plot(D$y)
lines(pred(lreg),col=2)
plot(resid(lreg))
```
<p align="center">
    <img src="https://raw.githubusercontent.com/hecro459/LinReg/master/predplot.png", width="400">
   <img src="https://raw.githubusercontent.com/hecro459/LinReg/master/resplot.png", width="400">
</p> 

## Testing

Testing was automated using <https://github.com/r-lib/testthat>. 
The specific R script with the tests is /mynewrpackage/tests/testthat/test_linreg_s3.R. 
Instructions for testing the package on RStudio:

1. Open RStudio and load the correspoing project.
2. Build the package: *Build* -> *Clean and Rebuild*.
3. Test the package: *Build* -> *Test Package*. If everything went fine, you should get an output like this in the right panel of RStudio:

<p align="left">
   <img src="https://raw.githubusercontent.com/hecro459/LinReg/master/test.png" width="400">





## License
LinReg is licensed under the GPLv2+
