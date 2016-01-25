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
    radius = sqrt((centerX-0).^2 + (centerY-0).^2)  %   distance formula
    arcTheta = arcLength / radius  %    full arclength in radians
    centerTheta = atan(centerY/centerX) %  radian pointing to arc center
    x_1 = radius * cos(centerTheta - arcTheta/2)
    y_1 = radius * sin(centerTheta - arcTheta/2)
    x_2 = radius * cos(centerTheta + arcTheta/2)
    y_2 = radius * sin(centerTheta + arcTheta/2)
    
    randNums = rand(1,100);
    points = randNums*arcLength + centerTheta - arcTheta/2;
    
    randMean = mean(randNums)
    randVar = var(randNums)
    
    scaledMean = mean(points)
    scaledVar = var(points)
    plot(points, ".")
 %   plot(cos(points), sin(points), ".")
 % will this go?
