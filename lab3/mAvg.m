%   jeff gray
%   jhg7nm
%   lab3
%   description: calculates moving average

function [movingAvg] = mAvg(inputVec)
%    clear;
    clc;
    
    %   error checking
    if (size(inputVec, 2) > 1)
        disp('ERROR: input is not a column vector!')
        disp('continuing anyway...')
    end
    
    movingAvg(1,1) = 0;      %   base case
    epsilon = .08;            %   setting rate constant, could be specified as parameter
   
    %    populate vector movingAvg while iterating through inputVec
    for i = 1 : length(inputVec) - 1
        movingAvg(1, i+1) = movingAvg(1, i) + epsilon * (inputVec(i,1) - movingAvg(1,i));
    end