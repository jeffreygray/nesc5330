##  jeff gray
##  01.24.2016
##  nesc5330
##  lab1
##  file: 'hw1-2-1.m' 
##  desc: 'calculates the mean, var, and sd for a vector'

function output = stats (dataset)
    sampleMean = mean(dataset);
    sampleVar = var(dataset);
    sampleStd = std(dataset);

output = [sampleMean, sampleVar, sampleStd];
endfunction
