#' Basic Linear Regression.
#'
#' \code{linreg} returns a S3 object of class linreg
#'
#' This function performs a basic linear regression model and return an object
#' for which a number of methods are defined to analyze the regression results.
#'
#' @export
#' @param formula A formula object contanining the model.
#' @param data An input data frame
#' @return An S3 object of class linreg 
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Linear_regression}
#' @import stats utils
linreg <- function(data,formula){
  X <- model.matrix(formula,data)
  y <- data[,all.vars(formula)[1]]
  Bhat <- solve(t(X)%*%X)%*%t(X)%*%y
  yhat <- X%*%Bhat
  #plot(y~X[,2])
  #lines(yhat~X[,2],col=2)
  ehat <- y-yhat
  df <- nrow(X)-nrow(Bhat)
  evar <- (t(ehat)%*%ehat)/df
  Bvar <- c(evar)*diag(solve(t(X)%*%X))
  tvalues <- Bhat/sqrt(Bvar)
  pvalues <- numeric(length(tvalues))
  for (i in 1:length(pvalues)){
    if (tvalues[i]<0) pvalues[i] <- 2*pt(tvalues[i],df)
    else pvalues[i] <- pvalues[i] <- 2*pt(-tvalues[i],df)
  }
  #Prepare data for class output
  coeff <- c(Bhat)
  names(coeff) <- rownames(Bhat)
  reg <- list(formula,coeff,yhat,ehat,Bvar,tvalues,pvalues,df)
  names(reg) <- c("Formula","Coefficients","yhat","ehat","Bvar","tvalues","pvalues","df")
  class(reg) <- "linreg" 
  return(reg)
}


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



#' @export
print.linreg <- function(x)
{
  cat(sprintf("linreg(formula = %s, data=iris)\n",(format(x$Formula))))
  cat(sprintf("%s",format(names(x$Coefficients))))
}

#' @export
#' @import ggplot2
plot.linreg <- function(x){
  yhat <- x$yhat
  ehat <- x$ehat
  f <- x$Formula
  outliers <- tail(order(abs(ehat)),3)
  stand_ehat <- sqrt(abs((ehat-mean(ehat))/sd(ehat)))
  p1 <- ggplot(data=NULL,aes(x = yhat, y = ehat)) + 
    geom_point() + 
    geom_smooth(method = "glm", se = FALSE, color = "red") +
    labs(title="Residuals vs Fitted",x=sprintf("Fitted_values\n %s",as.character(c(f))),y="Residuals") +
    geom_text(label = outliers,aes(x=yhat[outliers]-0.1,y=ehat[outliers])) + 
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5)) 
  
  #Standardized residuals 
  stand_ehat <- sqrt(abs((ehat-mean(ehat))/sd(ehat)))
  p2 <- ggplot(data=NULL,aes(x = yhat, y = stand_ehat)) + 
    geom_point() + 
    #geom_smooth(method = "lm", formula=stand_ehat~poly(yhat,6,raw=T),se = FALSE, color = "red") +
    geom_smooth(method = "glm", se = FALSE, color = "red") +
    labs(title="Scale-Location",x=sprintf("Fitted_values\n %s",as.character(c(f))),y=expression(sqrt(abs("Standardized Residuals")))) +
    geom_text(label = outliers,aes(x=yhat[outliers]-0.1,y=stand_ehat[outliers])) + 
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5)) 
  grid.arrange(p1, p2, ncol=2)
}

#' @export
resid.linreg <- function(x){
  return(x$ehat)
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
  n <- length(x$Coefficients)
  coeff <- x$Coefficients
  Bvar <- x$Bvar
  T <- x$tvalues
  P <- x$pvalues
  
  cat(sprintf("Coefficients\t\tSdError\t\tTvalue\t\tPvalue\n"))
  cat(sprintf("--------------------------------------------------------------\n"))
  for (i in 1:n){
    cat(sprintf("%s\t\t%f\t%f\t%f\n",strtrim(names(coeff[i]),15),Bvar[i],T[i],P[i]))
  }
  cat(sprintf("--------------------------------------------------------------\n"))
  cat(sprintf("Estimated error variance: %f\n",var(x$ehat)))
  cat(sprintf("Degrees of freedom: %d\n",x$df))
}

#TESTING THE METHODS
#data(iris)
#D = iris
#f <- Petal.Length~Species
#lreg <- linreg(D,f) #Creates an S3 object
#print(lreg) #Print out regression formula and coefficients
#plot(lreg) #Print residual plots
#resid(lreg) #Print residual plots
#pred(lreg)
#coef(lreg)
#summary(lreg)





