%   jeff gray
%   jhg7nm
%   02.15.2016
%   lab4
%   file: problem 4.1.3

function problemThree
    clc;
    clf;
    clear;
    rng(9711963);
    
    a = rand(50, 1) * pi/12 + pi/6 - pi/24;
    matA = ones(3, 50);
    for i = 1 : 50
        matA(1, i) = 1;
        matA(2, i) = cos(a(i,1));
        matA(3, i) = sin(a(i,1));
    end
    
    b = rand(50, 1) * pi/12 + pi/3 - pi/24;
    matB = ones(3, 50);
    for i = 1 : 50
        matB(1, i) = 1;
        matB(2, i) = cos(b(i,1));
        matB(3, i) = sin(b(i,1));
    end
    
    %   adding and shuffling both sets
    mat = [matA, matB];
    ix = randperm(100);
    shuf = mat(:, ix)
    
    graphA = catModStart(shuf, 0, 0)';

    %   plotting resultant convergences
    plot(graphA(:,1), graphA(:,2))
    axis('square')
    hold on
    plot(matA(2,:), matA(3,:),'.')
    plot(matB(2,:), matB(3,:),'.')




    
