library(fractaldim)

source('test_functions.R')

if (requireNamespace("RandomFields", quietly = TRUE)){
    library(RandomFields)    
    test.estimate.get()
    test.estimate.boxcount()
    test.estimate.sw.get()
    test.estimate.variation()
    test.estimate2d()
}
