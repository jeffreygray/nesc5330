function createfigure1()
clf;
clear;

rng(9711963);
randVec = rand(1000,1);
input = tAvg(randVec);

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'on');

% Create plot
plot(input);

% Create xlabel
xlabel('Iterations of tAvg','FontSize',11);

% Create ylabel
ylabel('Value of True Averager','FontSize',11);

% Create title
title('Iterations of Function tAvg and Associated Outputs','FontSize',11);

% Create textbox
annotation(figure1,'textbox',...
    [0.826985854189337 0.914122139338318 0.0946681150220036 0.0839694637151165],...
    'String',{'Jeff Gray','02.09.2016'},...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.710089849214986 0.134187576858853 0.181719254973923 0.311068693588253],...
    'String',{'Figure 1','This graph displays the','outputs of the tAvg','function using an input','of 1000 random numbers','from 0 to 1. The mean','inflects frequently during','the first 30 iterations, but','gradually stabilizes.'});

disp('checking to see if output is valid...')
actual = mean(randVec(1:1000),1)
calculated = input(1000,1)
