function controlledArc
clf
rng(9711963);
% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
xlim(axes1,[0 1]);
ylim(axes1,[0 1]);
box(axes1,'on');
hold(axes1,'on');

centerX = sqrt(3)/2;
centerY = .5;
arcLength = pi/8;

radius = sqrt((centerX-0).^2 + (centerY-0).^2);  %   distance formula
    arcTheta = arcLength / radius;  %    full arclength in radians
    centerTheta = atan(centerY/centerX); %  radian pointing to arc center
    
    %finding new points that serve as boundaries
    x_1 = radius * cos(centerTheta - arcTheta/2);
    y_1 = radius * sin(centerTheta - arcTheta/2);
    x_2 = radius * cos(centerTheta + arcTheta/2);
    y_2 = radius * sin(centerTheta + arcTheta/2);
    
    randNums = rand(1,100);
    scaledPoints = randNums*arcLength + centerTheta - arcTheta/2;

% Create plot
plot(cos(scaledPoints), sin(scaledPoints),'Marker','.','LineStyle','none');

% Create text
text('Parent',axes1,'String','Jeff Gray',...
    'Position',[0.905204460966543 1.05018587360595 0]);

% Create text
text('Parent',axes1,'String','01.26.2016',...
    'Position',[0.882899628252788 1.02230483271375 0]);

% Create xlabel
xlabel({'x = cos(scaledPoints)'},'FontSize',11);

% Create ylabel
ylabel({'y = sin(scaledPoints)'},'FontSize',11);

% Create title
title({'Sample Output of calculateAndPlot.m'},'FontSize',11);

% Create textbox
annotation(figure1,'textbox',...
    [0.252448313384114 0.692375194472734 0.269858534175242 0.195158844861609],...
    'String',{'Exercise 1.5.2','This plot contains the first','sample output from calculateAndPlot.m','The scaled mean exceeds the random','mean by .022 but the random','variance exceeds its scaled','counterpart by .0719.'});

