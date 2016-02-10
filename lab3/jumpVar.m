%   jeff gray
%   jhg7nm
%   lab3
%   description: runs problem 3.6B

function jumpVar
    %   standard clear routine
    clc;
    clf;
    rng(9711963);
    figure1 = figure;
    
    %   defining variables
    set1 = rand(500, 1) * .6 - .2;
    set2 = rand(500, 1) * .3 + .4;
    set = [set1; set2];
    data = mAvg(set)';
    
    %   plotting
    plot(mAvg(set))
    hold on
    
    for i = 1 : 1000
        varData(i, 1) = var(data(1:i));
    end
    plot(varData)
    xlabel('Iterations through Input')
    ylabel('Returned Value')
    title('Moving Average and Variance in a Jump Input Set')
    
    % Create legend
    legend1 = legend('show');

    annotation(figure1,'textbox',...
    [0.146810663764963 0.51824817518248 0.211187159956474 0.288321167883212],...
    'String',{'Figure 6','This plot represents mAvg.m','iterating through an input set','with 2 different patterns in','distribution. Upon reaching','the second pattern during the','input iteration, the variance','spikes up to 0.05.'},...
    'FitBoxToText','off');
    annotation(figure1,'textbox',...
    [0.824721436343853 0.917883211678831 0.0871392818280742 0.0766423357664232],...
    'String',{'Jeff Gray','02.09.2016'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
    axis([0 1000 0 .6])    