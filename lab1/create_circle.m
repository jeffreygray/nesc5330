function create_circle()
% remove possibly conflicting data
clf
clear

% create figure
figure1 = figure;

% create axes
axes1 = axes('Parent',figure1);
xlim(axes1,[-1.1 1.1]);
ylim(axes1,[-1.1 1.1]);
box(axes1,'on');
hold(axes1,'on');

% instantiate data for plot
points = [0:2*pi/1000:2*pi];

% create plot
plot(cos(points), sin(points));

% add text
text('Parent',axes1,'String',{'Jeff Gray','01.25.2016'},...
    'Position',[0.70471609403255 1.21139240506329 0]);

% add xlabel
xlabel('x-axis','FontSize',11);

% add ylabel
ylabel('y-axis','FontSize',11);

% add title
title('A Circle','FontSize',11);

% add textbox
annotation(figure1,'textbox',...
    [0.667985284421925 0.108116067008524 0.0950054262120613 0.118902435935125],...
    'String',{'Exercise 1.3','This is a labelled circle','oriented with the SQUARE','axis feature on MATLAB.'});

% set axis to square
axis('square')

