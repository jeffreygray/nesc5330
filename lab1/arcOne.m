function arcOne
% create figure
figure1 = figure;

% set up axes
axes1 = axes('Parent',figure1);
xlim(axes1,[0 1]);
ylim(axes1,[0 1]);
box(axes1,'on');
hold(axes1,'on');

dataset = rand(1,100)*pi/3 + pi/6;


% draw plot
plot(cos(dataset), sin(dataset),'Marker','.','LineStyle','none');
axis('square')
axis([0,1,0,1])

% Create text
text('Parent',axes1,'String','Jeff Gray',...
    'Position',[0.904850746268657 1.04850746268657 0]);

% Create text
text('Parent',axes1,'String','01.26.2016',...
    'Position',[0.878731343283582 1.0205223880597 0]);

% Create xlabel
xlabel('x = cos(dataset)','FontSize',11);

% Create ylabel
ylabel('y = sin(dataset)','FontSize',11);

% Create title
title('Uniformly distributed points along an arc from p/6 to p/2',...
    'FontSize',11);

% Create textbox
annotation(figure1,'textbox',...
    [0.569096844396084 0.120882804464532 0.229597381947479 0.144596647590263],...
    'String',{'Exercise 1.4.1','These points were created to','fit along the designated arc.','The data were instantiated','using uniformly random numbers'});

