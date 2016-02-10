%   jeff gray
%   jhg7nm
%   lab3
%   description: runs problem 3.3B.2

function bernoulli()
    clc;
    clf;
    rng(9711963);
    figure1 = figure;
    
    randNums = rand(1000,1);
    epsRanges = [.001:.001:1]';
    
    for i = 1 : 1000
        output(i, 1) = sqrt(mean((.5 - mAvgEps(randNums, epsRanges(i, 1)))));
    end

    plot(epsRanges, output)
    xlabel('?')
    ylabel('Root Mean Squared Deviation')
    title('The Effect of Rate Constant on RMSD')
    annotation(figure1,'textbox',...
    [0.826985854189336 0.933823529411765 0.105461371055495 0.0588235294117647],...
    'String',{'Jeff Gray','02.09.2016'},...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.622327529923831 0.648897065342787 0.26115342018005 0.237132346421919],...
    'String',{'Figure 5','This graph shows the relationship','between rate constant and RMSD.','Increases in the rate constant appear','inversely related to the resultant error,','which is represented mathematically','by the Bernoulli parameter p = 0.5'});

