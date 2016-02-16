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
    
    set1 = rand(50, 1) * pi/12 + pi/3 - pi/24;
    set2 = rand(50, 1) * pi/12 + pi/6 - pi/24;
    set = [set1; set2];
    plot(set)