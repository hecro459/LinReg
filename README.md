# Simple Linear Regression Package
[![Build Status](https://travis-ci.org/hecro459/LinReg.svg?branch=master)](https://travis-ci.org/hecro459/LinReg)

R package with a simple implementation of Linear Regression (OLS or Bayesian) using S3 classes.
The following functions are available:
* **linreg**:  Fits a linear regression model and creates an lreg object
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
   <img src="https://raw.githubusercontent.com/hecro459/LinReg/master/resplot.png" width="400">
    <img src="https://raw.githubusercontent.com/hecro459/LinReg/master/predplot.png" width="400">
</p> 



