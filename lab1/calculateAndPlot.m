%   jeff gray
%   01.24.2016
%   nesc5330
%   lab1
%   file: 'calculateAndPlot.m' 

% function description:
% given a center and arclength in radians,
% create points along arc
% calculate mean and variance of original rand[0,1) and scaled/shifted points
% compare the two sets of statistics

function output = calculateAndPlot (centerX, centerY, arcLength)
    clf
    rng(9711963);

    radius = sqrt((centerX-0).^2 + (centerY-0).^2);  %   distance formula
    arcTheta = arcLength / radius;  %    full arclength in radians
    centerTheta = atan(centerY/centerX); %  radian pointing to arc center
    
    %finding new points that serve as boundaries
    x_1 = radius * cos(centerTheta - arcTheta/2);
    y_1 = radius * sin(centerTheta - arcTheta/2);
    x_2 = radius * cos(centerTheta + arcTheta/2);
    y_2 = radius * sin(centerTheta + arcTheta/2);
    
    randNums = rand(1,100);
    scaledPoints = randNums*arcLength + centerTheta - arcTheta/2; % scaling and shifting random numbers
    
    % displaying output for comparison
    randMean = mean(randNums)
    randVar = var(randNums)
    scaledMean = mean(scaledPoints)
    scaledVar = var(scaledPoints)
    
    % plotting / formatting
    plot(cos(scaledPoints), sin(scaledPoints), '.')
    hold on
    axis ('square')

