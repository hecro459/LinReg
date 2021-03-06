#' Basic OLS Linear Regression.
#'
#' \code{linreg_ols} returns a S3 object of class linreg
#'
#' This function performs a basic linear regression model and return an object
#' for which a number of methods are defined to analyze the regression results.
#' Estimation is done using Ordinary-Least-Squares method.
#'
#' @export
#' @param formula A formula object contanining the model.
#' @param data An input data frame
#' @return An S3 object of class linreg 
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Linear_regression}
#' @import stats utils MASS
linreg_ols <- function(data,formula){
  X <- model.matrix(formula,data)
  y <- data[,all.vars(formula)[1]]
  n <- length(y)
  m <- ncol(X)
  
  rtype="freq"
  Bhat <- solve(t(X)%*%X)%*%t(X)%*%y
  yhat <- X%*%Bhat
  #plot(y~X[,2])
  #lines(yhat~X[,2],col=2)
  residuals <- y-yhat
  degreesFreedom <- nrow(X)-nrow(Bhat)
  evar <- (t(residuals)%*%residuals)/degreesFreedom
  Bvar <- c(evar)*diag(solve(t(X)%*%X))
  tvalues <- Bhat/sqrt(Bvar)
  pvalues <- numeric(length(tvalues))
  for (i in 1:length(pvalues)){
    if (tvalues[i]<0) pvalues[i] <- 2*pt(tvalues[i],degreesFreedom)
    else pvalues[i] <- pvalues[i] <- 2*pt(-tvalues[i],degreesFreedom)
  }
  
  #Prepare data for class output
  coeff <- c(Bhat)
  names(coeff) <- rownames(Bhat)
  reg <- list(formula,coeff,yhat,residuals,Bvar,tvalues,pvalues,degreesFreedom,rtype)
  names(reg) <- c("Formula","Coefficients","yhat","residuals","Bvar","tvalues","pvalues","degreesFreedom","rtype")
  class(reg) <- "linreg" 
  return(reg)
}

#' Basic Bayesian Linear Regression.
#'
#' \code{linreg_bayes} returns a S3 object of class linreg
#'
#' This function performs a basic linear regression model and return an object
#' for which a number of methods are defined to analyze the regression results.
#' Estimation is done using Bayesian inference with a flat multivariate normal prior.
#'
#' @export
#' @param formula A formula object contanining the model.
#' @param data An input data frame
#' @return An S3 object of class linreg 
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Linear_regression}
#' @import stats utils MASS
linreg_bayes <- function(data,formula){
  X <- model.matrix(formula,data)
  y <- data[,all.vars(formula)[1]]
  n <- length(y)
  m <- ncol(X)
  
  rtype="bayes"
  #no prior for sigma so we approximate it from data
  dataNoise <- ((max(y)-min(y))/4)**2
  #non-informative prior
  prior_variance = 1000
  mu0 <- numeric(m)
  Sigma0 <- diag(m)*prior_variance
  #calculation of posterior distribution
  SigmaStar <- dataNoise*solve(dataNoise*solve(Sigma0)+t(X)%*%X)
  muStar <- SigmaStar%*%solve(Sigma0)%*%mu0+1/dataNoise*(SigmaStar%*%t(X)%*%y)
  #take N samples from posterior and get betas 
  N_posterior_samples <- 1000000
  Bsample <- mvrnorm(N_posterior_samples,muStar,SigmaStar)
  Bhat <- as.matrix(apply(Bsample,2,mean))
  yhat <- X%*%Bhat
  residuals <- y-yhat
  degreesFreedom <- nrow(X)-nrow(Bhat)#Does it make sense in Bayesian?
  evar <- dataNoise
  Bvar <- as.matrix(apply(Bsample,2,var))
  tvalues <- numeric(m)#No t-values
  pvalues <- numeric(m)#or p-values in Bayesian!

  #Prepare data for class output
  coeff <- c(Bhat)
  names(coeff) <- rownames(Bhat)
  reg <- list(formula,coeff,yhat,residuals,Bvar,tvalues,pvalues,degreesFreedom,rtype)
  names(reg) <- c("Formula","Coefficients","yhat","residuals","Bvar","tvalues","pvalues","degreesFreedom","rtype")
  class(reg) <- "linreg" 
  return(reg)
}

#Definition of generic functions 

#' Print coefficients.
#'
#' \code{print.linreg} Print the coefficients of a linear regression model
#'
#' This function print the coefficients of a linear regression stored in an
#' object of class linreg.
#'
#' @export
#' @param x An object of class linreg contanining a linear regression.
print <- function(x){UseMethod("print",x)}

#' Residual plots.
#'
#' \code{plot.linreg} Generate residual plots of a linear regression model
#'
#' This function generate residual plots of a linear regression stored in an
#' S3 object of class linreg.
#'
#' @export
#' @param x An object of class linreg contanining a linear regression.
plot <- function(x){UseMethod("plot",x)}

#' Residuals
#'
#' \code{plot.linreg} Return vector of residuals from a linear regression model
#'
#' This function returns a vector of residuals from a linear regression stored in 
#' an S3 object of class linreg.
#'
#' @export
#' @param x An object of class linreg contanining a linear regression.
#' @return A numeric vector of residuals 
resid <- function(x){UseMethod("resid",x)}

#' Fitted values
#'
#' \code{plot.linreg} Return fitted values from a linear regression model
#'
#' This function returns the fitted values of a linear regression stored in 
#' an S3 object of class linreg.
#'
#' @export
#' @param x An object of class linreg contanining a linear regression.
#' @return A numeric vector of fitted values
pred <- function(x){UseMethod("pred",x)}

#' Regression coefficients
#'
#' \code{plot.linreg} Return estimated coefficients from a linear regression model
#'
#' This function returns estimated coefficients of a linear regression stored in 
#' an S3 object of class linreg.
#'
#' @export
#' @param x An object of class linreg contanining a linear regression.
#' @return A numeric vector with the estimated coefficients
coef <- function(x){UseMethod("coef",x)}

#' Regression summary
#'
#' \code{plot.linreg} Displays summary information of a fitted linear regression model
#'
#' This function displays the estimated coefficients and associated t-values and p-values
#' of a linear regression stored in an S3 object of class linreg. Also the estimated error
#' variance of the model and the degrees of freedom are shown.
#'
#' @export
#' @param x An object of class linreg contanining a linear regression.
summary <- function(x){UseMethod("summary",x)}

#Definition of methods

#' @export
print.linreg <- function(x)
{
  printModel <- function(formula,coefficients){
    cat(sprintf("linreg(formula = %s, data=iris)\n",(format(formula))))
    cat(sprintf("%s",format(names(coefficients))))
  }
  printModel(x$Formula,x$Coefficients)
}

#' @export
#' @import ggplot2 gridExtra 
plot.linreg <- function(x){
  residualVsFittedPlot <- function(yhat,residuals,f,outliers,stand_ehat){
    plot <- ggplot(data=NULL,aes(x = yhat, y = residuals)) + 
      geom_point() + 
      geom_smooth(method = "glm", se = FALSE, color = "red") +
      labs(title="Residuals vs Fitted",x=sprintf("Fitted_values\n %s",as.character(c(f))),y="Residuals") +
      geom_text(label = outliers,aes(x=yhat[outliers]-0.1,y=residuals[outliers])) + 
      #LiUtheme
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5)) 
    return(plot)
  }
  
  scaleLocationPlot <- function(yhat,residuals,f,outliers,stand_ehat){
    stand_ehat <- sqrt(abs((residuals-mean(residuals))/sd(residuals)))
    plot <- ggplot(data=NULL,aes(x = yhat, y = stand_ehat)) + 
    geom_point() + 
    #geom_smooth(method = "lm", formula=stand_ehat~poly(yhat,6,raw=T),se = FALSE, color = "red") +
    geom_smooth(method = "glm", se = FALSE, color = "red") +
    labs(title="Scale-Location",x=sprintf("Fitted_values\n %s",as.character(c(f))),y=expression(sqrt(abs("Standardized Residuals")))) +
    geom_text(label = outliers,aes(x=yhat[outliers]-0.1,y=stand_ehat[outliers])) + 
    #+ LiUtheme
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5)) 
    return(plot)
  }
  
  yhat <- x$yhat
  residuals <- x$residuals
  f <- x$Formula
  outliers <- tail(order(abs(residuals)),3)
  stand_ehat <- sqrt(abs((residuals-mean(residuals))/sd(residuals)))
  
  p1 <- residualVsFittedPlot(yhat,residuals,f,outliers,stand_ehat)
  p2 <- scaleLocationPlot(yhat,residuals,f,outliers,stand_ehat)
  grid.arrange(p1, p2, ncol=2)
}

#' @export
resid.linreg <- function(x){
  return(x$residuals)
}

#' @export
pred.linreg <- function(x){
  return(x$yhat)
}

#' @export
coef.linreg <- function(x){
  return(x$Coefficients)
}

#' @export
summary.linreg <- function(x){
  printSummary <- function(coeff,Bvar,tvalues,pvalues,n){
    cat(sprintf("Coefficients\t\tSdError\t\tTvalue\t\tPvalue\n"))
    cat(sprintf("--------------------------------------------------------------\n"))
    for (i in 1:n){
      cat(sprintf("%-15s\t\t%6.6f\t%6.6f\t%6.6f\n",strtrim(names(coeff[i]),15),Bvar[i],tvalues[i],pvalues[i]))
    }
    cat(sprintf("--------------------------------------------------------------\n"))
    cat(sprintf("Estimated error variance: %f\n",var(x$residuals)))
    cat(sprintf("Degrees of freedom: %d\n",x$degreesFreedom))
  }
  
  n <- length(x$Coefficients)
  coeff <- x$Coefficients
  Bvar <- x$Bvar
  T <- x$tvalues
  P <- x$pvalues
  printSummary(coeff,Bvar,T,P,n)
}







