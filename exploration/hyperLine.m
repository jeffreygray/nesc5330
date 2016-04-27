%   jeff gray
%   jhg7nm
%   02.24.2016

%   description: creates hyperline to separate inputs
%   can solve the XOR problem

function hyperLine()
    close all, clear all, clc, format compact
    
    %%  define inputs
    % number of samples of each class
    K = 100;
    % define 4 clusters of input data
    q = .6; % offset of classes
    A = [rand(1,K)-q; rand(1,K)+q];
    B = [rand(1,K)+q; rand(1,K)+q];
    C = [rand(1,K)+q; rand(1,K)-q];
    D = [rand(1,K)-q; rand(1,K)-q];
    
    %%  define outputs   
    a = -1; % a | b
    c = -1; % -------
    b = 1; % d | c
    d = 1; %
    
    %%  I/O training
    %   preparation
    % define inputs (combine samples from all four classes)
    % P = [A B C D];
    % define targets
    T = [repmat(a,1,length(A)) repmat(b,1,length(B)) ...
     repmat(c,1,length(C)) repmat(d,1,length(D)) ];
    % view inputs |outputs
    %[P' T']
    % create a neural network
    
    %   creation
    net = feedforwardnet([5 3]);
    % train net
    net.divideParam.trainRatio = 1; % training set [%]
    net.divideParam.valRatio = 0; % validation set [%]
    net.divideParam.testRatio = 0; % test set [%]
    % train a neural network
    [net,tr,Y,E] = train(net,P,T);
    % show network
    view(net)
    
    %%  plotting
    %   first cluster
    figure(1)
    plot(A(1,:),A(2,:),'k+')
    hold on
    grid on
    plot(B(1,:),B(2,:),'bd')
    plot(C(1,:),C(2,:),'k+')
    plot(D(1,:),D(2,:),'bd')
    % text labels for clusters
    text(.5-q,.5+2*q,'Class A')
    text(.5+q,.5+2*q,'Class B')
    text(.5+q,.5-2*q,'Class A')
    text(.5-q,.5-2*q,'Class B')

    
    %   performance analysis
    figure(2)
    plot(T','linewidth',2)
    hold on
    plot(Y','r--')
    grid on
    legend('Targets','Network response','location','best')
    ylim([-1.25 1.25])
        text(.5-q,.5-2*q,'Class B')
        
    %   input space
    % generate a grid
    span = -1:.005:2;
    [P1,P2] = meshgrid(span,span);
    pp = [P1(:) P2(:)]';
    % simulate neural network on a grid
    aa = net(pp);
    % translate output into [-1,1]
    %aa = -1 + 2*(aa>0);
    % plot classification regions
    figure(1)
    mesh(P1,P2,reshape(aa,length(span),length(span))-5);
    colormap cool
    view(2)
    
    point = [0; 1]
    test = net(point)