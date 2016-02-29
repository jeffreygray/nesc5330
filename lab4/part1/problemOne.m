%   jeff gray
%   jhg7nm
%   02.15.2016
%   lab4
%   file: problem 4.1.1

function [output] =  problemOne
    clc;
    clear;
    rng(9711963);

    %   making matricies that agree with other functions
        %   centered at pi/6
    a = rand(100, 1) * pi/12 + pi/6 - pi/24;
    matA = ones(3, 100);
    for i = 1 : 100
        matA(1, i) = 1;
        matA(2, i) = cos(a(i,1));
        matA(3, i) = sin(a(i,1));
    end
        %   centered at pi/4
    b = rand(100, 1) * pi/12 + pi/4 - pi/24;
    matB = ones(3, 100);
    for i = 1 : 100
        matB(1, i) = 1;
        matB(2, i) = cos(b(i,1));
        matB(3, i) = sin(b(i,1));
    end
        %   centered at pi/3
    c = rand(100, 1) * pi/12 + pi/3 - pi/24;
    matC = ones(3, 100);
    for i = 1 : 100
        matC(1, i) = 1;
        matC(2, i) = cos(c(i,1));
        matC(3, i) = sin(c(i,1));
    end
    
    %   plotting
    graphA = catMod(matA)';
    graphB = catMod(matB)';
    graphC = catMod(matC)';
    plot(graphA(:,1), graphA(:,2), '.')
    hold on
    plot(graphB(:,1), graphB(:,2), '.')
    hold on
    plot(graphC(:,1), graphC(:,2), '.')
    axis('square',[0 1 0 1])
    
    %   imposing lines of weight vectors
    line([0 cos(pi/6)], [0 sin(pi/6)])
    line([0 cos(pi/4)], [0 sin(pi/4)])
    line([0 cos(pi/3)], [0 sin(pi/3)])
    
    
    
    
    