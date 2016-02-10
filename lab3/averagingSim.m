%   jeff gray
%   jhg7nm
%   lab3
%   description: runs problem 3.3B

function averagingSim()
    clc;
    clf;
    figure1 = figure;
    
    randNums = rand(1000000, 1) + 0.3;    %   generating 1m random numbers centered at 0.8
    
    %   plotting
    plot(randNums)
    hold on
    line([0 1000000], [.8, .8])
    hold on
    
    %   formatting plot and adding text
    axis([1000000-100 1000000 0 1.3])
    annotation(figure1,'textbox',...
    [0.826985854189336 0.938432835820895 0.0891392818280741 0.0541044776119401],...
    'String',{'Jeff Gray','02.09.2016'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
annotation(figure1,'textbox',...
    [0.714866003419867 0.132924668073611 0.176278558726928 0.20895521820926],...
    'String',{'Figure 4','This plot demonstrates','convergence within the','last 100 iterations of','mAvg on a random','dataset centered at 0.8.'});
    title('Extreme Convergence of a Moving Averager to p=0.8')
    xlabel('Iterations')
    ylabel('Value of Moving Averager')

    
    
