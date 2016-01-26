%   jeff gray
%   01.24.2016
%   nesc5330
%   lab1
%   file: 'randHist.m'

%   lab 1 exercise 1.7

function randHist
rng(9711963);
data = rand(1,1000);
[bin_values, bin_position] = hist(data, 20);

% assign figure
figure1 = figure;

% format axes
axes1 = axes('Parent',figure1);
xlim(axes1,[0 1]);
ylim(axes1,[0 70]);
box(axes1,'on');
hold(axes1,'on');

% Create bar
bar(bin_position, bin_values);

% add xlabel
xlabel('Centered Bin Locations','FontSize',11);

% add ylabel
ylabel('Bin Counts','FontSize',11);

% add title
title('One Thousand Uniform Random Numbers','FontSize',11);

% add textbox
annotation(figure1,'textbox',...
    [0.272921762926867 0.790294627383015 0.40169490378792 0.125802811657635],...
    'String',{'Exercise 1.7','This is a histogram with 20 bars','that represent the distribution and','frequency of 1000 random numbers'},...
    'FitBoxToText','on');

