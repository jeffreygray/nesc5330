%   jeff gray
%   jhg7nm
%   lab3
%   description: runs problem 3.2.2

function converge(input, eps1, eps2, eps3)
clf;
clc;
rng(9711963);
figure1 = figure;

plot(mAvgEps(input, eps1))
hold on
plot(mAvgEps(input, eps2))
hold on
plot(mAvgEps(input, eps3))

axis([0 100 0 1.1])
xlabel('Iterations')
ylabel('Value of Moving Averager')
title('Convergence of Moving Averager')
annotation(figure1,'textbox',...
    [0.661500544069641 0.426691736941946 0.230685521196878 0.274436082606925],...
    'String',['Figure 3',sprintf('\n'),'Given an input set of 100 ones,',sprintf('\n'),'the highest rate contant in blue',sprintf('\n'),'reflects its adaptability by quickly',sprintf('\n'),'inflecting to the convergent value',sprintf('\n'),'of 1. The lower the rate constant',sprintf('\n'),'drops, the less able it is to',sprintf('\n'),'account for change.']);
annotation(figure1,'textbox',...
    [0.829142002176279 0.900877192982455 0.140071428571429 0.0928571428571456],...
    'String',{'Jeff Gray','02.09.2016'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
