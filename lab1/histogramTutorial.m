%   jeff gray
%   01.24.2016
%   nesc5330
%   lab1
%   file: 'histogramTutorial.m'

%   description: copy of code used to walkthrough tutorial instructions

function histogramTutorial

data = rand(1,1000); %creating random values in 1D vector
[bin_values, bin_position] = hist(data, 20); %calling hist() to populate new variables
bar(bin_values); %create bar graph with bad x-labels
bar(.025: .05: .975, bin_values); %create bar with better x-labels and offset
total_count = sum(bin_values); %equals 1000!
bar(bin_position, bin_values/total_count); %relative frequency histogram