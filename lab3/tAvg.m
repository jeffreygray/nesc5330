%   jeff gray
%   jhg7nm
%   lab3
%   description: calculates true average

function [trueAvg] = tAvg(inputVec)
%    clear;
    clc;
    
    %   error checking
    if (size(inputVec, 2) > 1)
        disp('ERROR: input is not a column vector!')
        disp('continuing anyway...')
    end
    
    curAvg = 0; %   base case
    
    %   populate vector trueAvg by iterating through inputVec
    for i = 1 : length(inputVec)
        curAvg = (curAvg*(i-1) + inputVec(i,1))/i;
        trueAvg(i,1) = curAvg;
    end
    