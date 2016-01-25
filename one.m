%{
function [outputOne, outputTwo] = functionOne(inputData)
outputOne = mean(inputData);
outputTwo = var(dataset);
%}

function [samplemean, samplevariance] = stats(dataset)
Samplemean = mean(dataset);
Samplevariance = var(dataset);
