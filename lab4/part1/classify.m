%   jeff gray
%   jhg7nm
%   02.15.2016
%   lab4
%   file: classify.m
%   desc: declare category given inputs

%   parameter: 3xN input matrix of N vector inputs
%   output: 2x1 synaptic weight vector
function [output] = classify(inputVec, thresh)
    %   error checking
    if (size(inputVec, 1) ~= 2)
        disp('ERROR: input is not of size 2xN!')
    end

    %   forward declarations
    weight1 = [cos(pi/6), sin(pi/6)];
    weight2 = [cos(pi/4), sin(pi/4)];
    weight3 = [cos(pi/3), sin(pi/3)];
    thresh = thresh;
    
    stateA = dot(inputVec, weight1) % > cos(thresh);
    stateB = dot(inputVec, weight2) % > cos(thresh);
    stateC = dot(inputVec, weight3) % > cos(thresh);
%    output = [stateA, stateB, stateC]';
    
    if (weight1 > weight2 && weight1 > weight3)
        output = stateA;
    end
    if (weight2 > weight1 && weight2 > weight3)
        output = stateB;
    end
    else output = stateC;
    
