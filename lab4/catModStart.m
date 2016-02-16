%   jeff gray
%   jhg7nm
%   02.15.2016
%   lab4
%   file: catModStart.m
%   desc: added features to catMod.m

%   parameter: 3xN input matrix of N vector inputs, coords
%   output: 2x1 synaptic weight vector
function [synW] = catModStart(inputMat, xstart, ystart)
    %   error checking
    if (size(inputMat, 1) ~= 3)
        disp('ERROR: input is not of size 3xN!')
    end

    %   forward declarations
    epsilon = 0.2;
    synW = ones(2,size(inputMat, 2));
    synW(1, 1) = xstart;
    synW(2, 1) = ystart;
    
    %   perform a moving average on inputs
    %   given a state of category activation
    for i = 1 : size(inputMat, 2)
        if (inputMat(1,i) == 1)
            %   update first attribute
            synW(1, i+1) = synW(1, i) + epsilon ...
            * (inputMat(2, i) - synW(1, i));
            %   update second attribute
            synW(2, i+1) = synW(2, i) + epsilon ...
            * (inputMat(3, i) - synW(2, i));
        end
    end
