%   jeff gray
%   01.24.2016
%   nesc5330
%   lab1
%   file: 'calculateAndPlot.m' 

% given a center and length in radians,
% create points along arc
% calculate mean and variance of original rand[0,1) and scaled/shifted points
% compare the two sets of statistics

function output = calculateAndPlot (centerX, centerY, arcLength)
    radius = sqrt((centerX-0).^2 + (centerY-0).^2)
    theta = arcLength / radius * 180 / pi

    
    newX = radius*(cos(theta*pi/180))
    newY = radius*(sin(theta*pi/180))
endfunction
