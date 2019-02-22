context("linreg")
data("iris")

#Testing for errorneous input in linreg_ols function
test_that("linreg_ols rejects errounous input", {
  expect_error(linreg_ols(Petal.Length~Sepdsal.Width+Sepal.Length, data=iris))
  expect_error(linreg_ols(Petal.Length~Sepdsal.Width+Sepal.Length, data=irfsfdis))
  expect_error(linreg_ols("this is not a formula!", data=iris))
})

#Testing for errorneous input in linreg_bayes function
test_that("linreg_bayes rejects errounous input", {
  expect_error(linreg_ols(Petal.Length~Sepdsal.Width+Sepal.Length, data="nothing"))
  expect_error(linreg_ols(Petal.Length~Sepdsal.Width+Sepal.Length, data=iris))
  expect_error(linreg_ols("this is not a formula!", data=iris))
})

#Testing that the returned object is from the correct class
test_that("class is correct", {
  linreg_mod1 <- linreg_ols(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_s3_class(linreg_mod1, "linreg")
  linreg_mod2 <- linreg_bayes(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_s3_class(linreg_mod2, "linreg")
})

#test_that("print() works", {
#  linreg_mod <- linreg(Petal.Length~Sepal.Width+Sepal.Length, data=iris)

  #expect_output(print(linreg_mod),"linreg\\(formula = Petal\\.Length ~ Sepal\\.Width \\+ Sepal\\.Length, data = iris\\)")
  #expect_output(print(linreg_mod)," \\(Intercept\\)   Sepal\\.Width  Sepal\\.Length")
#})

#Testing that the fitted values from regression are correct
test_that("pred() works", {
  linreg_mod1 <- linreg_ols(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_equal(round(unname(pred(linreg_mod1)[c(1,5,7)]),2), c(1.85, 1.53, 1.09))
  linreg_mod2 <- linreg_bayes(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_equal(round(unname(pred(linreg_mod2)[c(1,5,7)]),2), c(1.85, 1.53, 1.09))    
})

#Testing that the residuals from regression are correct
test_that("resid() works", {
  linreg_mod1 <- linreg_ols(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_equal(round(unname(resid(linreg_mod1)[c(7,13,27)]),2), c(0.31, -0.58, -0.20))
  linreg_mod2 <- linreg_bayes(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_equal(round(unname(resid(linreg_mod2)[c(7,13,27)]),2), c(0.31, -0.58, -0.20))
})

test_that("coef() works", {
  linreg_mod <- linreg_ols(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_true(all(round(unname(coef(linreg_mod)),2) %in% c(-2.52, -1.34, 1.78)))
})


#test_that("summary() works", {
#  linreg_mod <- linreg(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
#  
#  expect_output(summary(linreg_mod), "\\(Intercept\\)( )*-2.5[0-9]*( )*0.5[0-9]*( )*-4.4[0-9]*( )*.*( )*\\*\\*\\*")  
#  expect_output(summary(linreg_mod), "Sepal.Width( )*-1.3[0-9]*( )*0.1[0-9]*( )*-10.9[0-9]*( )*.*( )*\\*\\*\\*")
#  expect_output(summary(linreg_mod), "Sepal.Length( )*1.7[0-9]*( )*0.0[0-9]*( )*27.5[0-9]*( )*.*( )*\\*\\*\\*")
#  expect_output(summary(linreg_mod), "Residual standard error: 0.6[0-9]* on 147 degrees of freedom")
#})

