# Simple Linear Regression Package
[![Build Status](https://travis-ci.org/hecro459/LinReg.svg?branch=master)](https://travis-ci.org/hecro459/LinReg)

R package with a simple implementation of Linear Regression using S3 classes.
The following functions are available:
* **linreg** Fits a linear regression model and creates an lreg object
* **print** Prints out the regression formula
* **coef** Returns the 
* **resid** Returns residuals
* **pred** Returns fitted values
* **plot** Plot regression fit
* **summary** Prints out summary of regression

## Example
```r
data(iris)
D = iris
f <- Petal.Length~Species
lreg <- linreg(D,f) 
summary(lreg)
plot(resid(lreg))
```