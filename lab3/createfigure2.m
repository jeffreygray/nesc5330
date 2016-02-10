%   jeff gray
%   jhg7nm
%   lab3
%   description: creates figure 2

function createfigure2()
clf;
clc;
clear;

rng(9711963);
randInput = rand(1000,1);
input = tAvg(randInput);

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 1000]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 0.8]);
box(axes1,'on');
hold(axes1,'on');

% Create plot
plot(tAvg(randInput));
hold on
plot(mAvg(randInput));
hold on
plot([0 1000], [mean(randInput) mean(randInput)])
hold on
plot([0 1000], [mean(randInput)+std(randInput) mean(randInput)+std(randInput)])
hold on
plot([0 1000], [mean(randInput)-std(randInput) mean(randInput)-std(randInput)])
axis([0 1000 0 .8])

% Create xlabel
xlabel('Iterations','FontSize',11);

% Create ylabel
ylabel('Value of Averager','FontSize',11);

% Create title
title('Behavior of Exact vs Moving Averager','FontSize',11);

% Create textbox
annotation(figure1,'textbox',...
    [0.539535675423598 0.169859314076119 0.349292699381369 0.244318175101371],...
    'String',{'Figure 2','This plot displays the output of functions mAvg','and tAvg with the same input set of random','numbers. Although both averagers behave similarly','under100 iterations,the moving average becomes','periodic and begins to sinusoid while the exact','averager results in a tighter fit with the mean line.'});

legend(axes1,'show');

% Create textbox
annotation(figure1,'textbox',...
    [0.825897714907509 0.910984850403937 0.0946681150220036 0.0833333314142445],...
    'String',{'Jeff Gray','02.09.2016'},...
    'EdgeColor','none');

