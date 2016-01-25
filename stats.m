##  jeff gray
##  01.24.16
##  nesc5330
##  lab1
##  file method.m 

function output = stats (dataset)
sampleMean = mean(dataset);
sampleVar = var(dataset);

output = [sampleMean, sampleVar];
endfunction
