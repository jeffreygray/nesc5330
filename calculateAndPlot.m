%   jeff gray
%   01.24.2016
%   nesc5330
%   lab1
%   file: 'calculateAndPlot.m' 

% given a center and length in radians,
% create points along arc
% calculate mean and variance of original rand[0,1) and scaled/shifted points
% compare the two sets of statistics

function output = calculateAndPlot (center, arcLength)
    [a, b] = center
    radius = sqrt((a-0).^2 + (b-0).^2)
    theta = arcLength / radius
    arcDist = theta / 360 * 2 * pi * radius


endfunction
