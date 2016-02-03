function thresholdOne(err1, err2)
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(err1);
hold
plot2 = plot(err2);
set(plot1,'DisplayName','TYPE I');
set(plot2,'DisplayName','TYPE II');

% Create text
text('Parent',axes1,'String','Jeff Gray',...
    'Position',[5.65918653576438 1.05321100917431 0]);

% Create text
text('Parent',axes1,'String','02.02.2016',...
    'Position',[5.55399719495091 1.02385321100917 0]);

% Create xlabel
xlabel({'Iterations of Threshold Increases'},'FontSize',11);

% Create ylabel
ylabel({'Relative Frequency of Errors'},'FontSize',11);

% Create title
title({'Type I and II Errors Graphed as a Function of Threshold'},...
    'FontSize',11);

% Create legend
legend(axes1,'show');

