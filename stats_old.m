##  jeff gray
##  01.24.16
##  nesc5330
##  lab1
##  file method.m 

   
##function output = stats(dataset)

##function [ sampleMean, sampleVar, sampleStd ] = stats(dataset);
function output = stats(dataset)
    sampleMean = mean(dataset);
    sampleVar = var(dataset);
    sampleStd = std(dataset);
    
    output = [sampleMean, sampleVar, sampleStd];
endfunction
