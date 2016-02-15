%   jeff gray
%   jhg7nm
%   02.15.2016
%   lab4
%   file: problem 4.1.1

function problemOne
    clc;
    clear;
    rng(9711963);

    %   making matricies that agree with other functions
        %   centered at pi/6
    a = rand(10, 1) * pi/12 + pi/6 - pi/24;
    setA = [cos(a), sin(a)];
    matA = ones(3, 10);
    for i = 1 : 10
        matA(1, i) = 1;
        matA(2, i) = cos(a);
        matA(3, i) = sin(a);
    end
        %   centered at pi/4
    b = rand(10, 1) * pi/12 + pi/4 - pi/24;
    setB = [cos(b), sin(b)];
    matC = ones(3, 10);
    for i = 1 : 10
        matB(1, i) = 1;
        matB(2, i) = cos(b);
        matB(3, i) = sin(b);
    end
        %   centered at pi/3
    c = rand(10, 1) * pi/12 + pi/3 - pi/24;
    setC = [cos(c), sin(c)];
    matC = ones(3, 10);
    for i = 1 : 10
        matC(1, i) = 1;
        matC(2, i) = cos(c);
        matC(3, i) = sin(c);
    end

    plot(catMod(matA))

