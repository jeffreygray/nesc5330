%   jeff gray
%   jhg7nm
%   02.15.2016
%   lab4
%   file: problem 4.1.2

function [output] =  problemTwo
    clc;
    clf;
    clear;
    rng(9711963);

    %   matrix centered at pi/3
    c = rand(100, 1) * pi/12 + pi/3 - pi/24;
    matC = ones(3, 100);
    for i = 1 : 100
        matC(1, i) = 1;
        matC(2, i) = cos(c(i,1));
        matC(3, i) = sin(c(i,1));
    end
    
    %   initializing function at arbitrary coordinates
    graphA = catModStart(matC, 0, 0)';
    graphB = catModStart(matC, 1, 0)';
    graphC = catModStart(matC, 0, 1)';
    graphD = catModStart(matC, 1, 1)';

    %   plotting resultant convergences
    plot(graphA(:,1), graphA(:,2))
    hold on
    plot(graphB(:,1), graphB(:,2))
    hold on
    plot(graphC(:,1), graphC(:,2))
    hold on
    plot(graphD(:,1), graphD(:,2))    
    axis('square',[0 1 0 1])
    
    
    
    
    
    