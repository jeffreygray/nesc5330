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
    arcTheta = arcLength / radius * 180 / pi
    centerTheta = atan((centerY*180)/(centerX*pi))
    x_1 = radius * cos(centerTheta - arcTheta/2)
    y_1 = radius * sin(centerTheta - arcTheta/2)
    x_2 = radius * cos(centerTheta + arcTheta/2)
    y_2 = radius * sin(centerTheta + arcTheta/2)
    

    
%    newX = radius*(cos(theta*pi/180))
%    newY = radius*(sin(theta*pi/180))
endfunction
