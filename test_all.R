library(methods)
library(devtools)
library(testthat)

if (interactive()) {
  load_all(".")
} else {
  library(scc)
}

test_dir("tests/testthat")
