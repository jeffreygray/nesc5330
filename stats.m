##  jeff gray
##  01.24.16
##  nesc5330
##  lab1
##  file method.m 

   
##function output = stats(dataset)


##    output = [sampleMean, sampleVar];
    
function [sampleMean, sampleVar] = stats(dataset)
    sampleMean = mean(dataset);
    sampleVar = var(dataset);

endfunction
