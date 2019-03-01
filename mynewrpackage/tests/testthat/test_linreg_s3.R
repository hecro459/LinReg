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

#Testing that we get correct regression estimated coefficients
test_that("coef() works", {
  linreg_mod1 <- linreg_ols(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_true(all(round(unname(coef(linreg_mod1)),2) %in% c(-2.52, -1.34, 1.78)))
  linreg_mod2 <- linreg_bayes(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_true(all(round(unname(coef(linreg_mod2)),2) %in% c(-2.52, -1.34, 1.78)))
})

#Testing that the output for the summary function is correct
test_that("summary() works", {
  linreg_mod1 <- linreg_ols(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_output(summary(linreg_mod1), ".*\\(Intercept\\).*0\\.31.*-4\\.48.*0\\.00.*")
  expect_output(summary(linreg_mod1), ".*Sepal\\.Width.*0\\.014.*-10\\.94.*0\\.00.*")
  expect_output(summary(linreg_mod1), ".*Sepal\\.Length.*0\\.004.*27\\.56.*0\\.00.*")
  linreg_mod2 <- linreg_bayes(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
  expect_output(summary(linreg_mod2), ".*\\(Intercept\\).*1\\.6.*0\\.0.*0\\.00.*")
  expect_output(summary(linreg_mod2), ".*Sepal\\.Width.*0\\.07.*0\\.00.*0\\.00.*")
  expect_output(summary(linreg_mod2), ".*Sepal\\.Length.*0\\.02.*0\\.00.*0\\.00.*")
})

#Testing that the output for the printed model details are correct
test_that("print() works", {
linreg_mod1 <- linreg_ols(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
expect_output(print(linreg_mod1),"linreg\\(formula = Petal\\.Length ~ Sepal\\.Width \\+ Sepal\\.Length, data=iris\\)")
expect_output(print(linreg_mod1),"\\(Intercept)  Sepal\\.Width  Sepal\\.Length")
linreg_mod2 <- linreg_bayes(Petal.Length~Sepal.Width+Sepal.Length, data=iris)
expect_output(print(linreg_mod2),"linreg\\(formula = Petal\\.Length ~ Sepal\\.Width \\+ Sepal\\.Length, data=iris\\)")
expect_output(print(linreg_mod2),"\\(Intercept)  Sepal\\.Width  Sepal\\.Length")
})




