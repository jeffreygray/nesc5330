%   02.01.2016
%   nesc5330
%   lab1
%   file: 'spikegen.m'

%   description: generates neuron output!

function [neuron_output] = getOutputs(innerProd, thresh)
%   threshold and excitation must be scalars

    neuron_output = innerProd > cos(thresh);

%   error detection
%    if length(excitation) > 1
%        disp('ERROR: spikegen.m takes a scalar not a vector or matrix')
%    end
    
%    if excitation < threshold
%        neuron_output = 0;
%    else
%        neuron_output = 1;
%    end