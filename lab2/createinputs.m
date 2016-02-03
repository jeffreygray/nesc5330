%   jeff gray
%   jhg7nm
%   02.2.2016
%   nesc5330
%   lab1
%   file: 'createinputs.m'

%   description: creates input matrix of given dimension with random values

function [inputs] = createinputs(row, col, numInputs, range, offset)
%   including numInputs despite its redundance

%   error detect
        if (row*col ~= numInputs)
            disp('ERROR: your input parameters do not agree! check them.')
        end
 
        inputs = rand(row, col) * range + offset;
        