%   jeff gray
%   jhg7nm
%   lab4.5
%   02.23.2016

% clear all
 
%% parameters (free variables/ independant variables)
% time params (have to be integers)------------------------
pad_len = 5; % the inital time period that the cerebellum does not receive any input
CS_len = 12; % the length of CS
US_len = 2; % US_len < CS_len
end_len = 15; % the final time period that the cerebellum does not receive any input
              % this parameter is needed for plotting because the
              % activities of neurons extends beyond the time CS and US
              % occur
session = 16; % the number of sessions
trialPsession = 100; % the number of trials per session
CS_switch = 1; %0: off; 1: on
US_switch = 1; %0: off; 1: on
trace = 0; % 0: trace conditioning is off; you can try making it greater 
           %than 0 and see whether the system learns
change = 9*100; % if you want to change the CSUS combination in the middle of the simulation
                % to see how the cerebellum responses to one kind of CSUS
                % combination right after another kind, put the number of
                % the first trial that you want to simulate with the second
                % set of CSUS

% constants of the system-------------
% time constant
eps1 = 0.0005; % time constant for granule-pc synapses
eps2 = 0.0005; % time constant for granule-SCBC synapses

% initial weights (use one of the sets below)-----------------
% (1) self-defined weights 
w1 = 0.55;
w2 = 0.45;
% (2)-(3) are hard coded initial weights for asymptotic responses(these weights may not be correct)----
% % (2) Habituation 
% w1 = .4352; % initial weight of granule-pc 
% w2 = .5648; % initial weight of granule-SCBC
% % (3) Learned
% w1 = .3833; % initial weight of granule-pc 
% w2 = .7167; % initial weight of granule-SCBC
% % (4) Continue with the last set of weights from the previous training
% w1 = w1_(Ntrain);
% w2 = w2_(Ntrain);

% internal excitations----------------
inPc = 1/2; % the perkinje cell
inDcn = 1; % the deep nucleus
inIO = 0.005; % the inferior olive: IO has a spontaneous firing rate about 1Hz
              % but has maximum firing rate around 200Hz, so the relative
              % activity during spontaneous firing is 1Hz/200Hz=0.005

% weights that do not change-----------
w_dcn = 1/inPc; % ensures the no input steady-state DCN = 0
mot_0=.5; mot_1=1; % these two parameters defines how the activity of the muscle
                   % carrys on to the next timestep 
                   % ##"mot" standands for both the activity of the muscle that release the nictitating membrane##
                   % ## and the activity of accessory abducens nucleus ##

% thresholds--------------
% mot_threshold = .7; % not used (ignore it)
blink_threshold = .8; % the threashold of activity of the muscle to count as one blink

%% initializations
% setup US, CS, and time vectors-------
[CS, US] =CSUS(pad_len,CS_len,US_len,end_len,CS_switch,US_switch,trace);
t = 1:length(CS); % time vector
len = length(CS);
Ntrain = session*trialPsession; % the total number of training trials

% initializations (housekeeping)
mot = zeros(1,len);
trig = zeros(1,len);
bl = zeros(1,len);
pot = zeros(1,len);
gran = zeros(1,len);
SB = zeros(1,len);
pc = ones(1,len)*inPc; % spontaneous activity
dcn1 = inDcn-w_dcn*pc; % make sure this is not negative
dcn2 = inDcn-w_dcn*pc; % make sure this is not negative
rn = zeros(1,len);
err = zeros(1,len);  
cf = ones(Ntrain,len)*inIO; % spontaneous activity

% initializations for recording output of each trial
% the parameters with '_' in the end are housekeeping parameters which
% keep track of the entire simulation. They are also used for plotting the
% results of the simulation
w1_=zeros(Ntrain,len);
w2_=zeros(Ntrain,len);
er_=zeros(Ntrain,len);
w1_(1,:)=w1;
w2_(1,:)=w2;
rn_=zeros(1,Ntrain);
cf_=zeros(1,Ntrain);
pc_=zeros(1,Ntrain);
bl_=zeros(1,Ntrain);

% other params

%% simulation
% random number generations for the noise -------------------
rng(15); % try different seeds
r1=rand(Ntrain,len);
rng(16);
r2=rand(Ntrain,len);

% the actual simulation for loop
% 1 loop = 1 training trail
for train=1:Ntrain
    if train==change % switching CSUS combination 
        US_switch =0;
        [CS, US] =CSUS(pad_len,CS_len,US_len,end_len,CS_switch,US_switch,trace);
    end
    
    for i=1:len-5 % -5 because the largest offset of i is +5 (+5 for RN)
        % the simple ones ----------------
        pot(i+1)=CS(i); % potine cell: activated by CS
        trig(i+2)=US(i)*(US(i)-mot(i)); % with negative feedback from the muscle 
                                        % spinal trigeminal: activated by US but blinks block US 
        gran(i+2)=pot(i+1);  % ganule cell is only activated by potine nucleus        
        mot(i+2)=capF(mot_1*(rn(i+1)+trig(i+2))+mot_0*mot(i+1));% accessory 
                             % abducens nucleus (activates two 
                             % timesteps by one stimulus with high
                             % enough intensity)
        if mot(i+2)<0.05 % the activity is considered zero when it is below 0.05
            mot(i+2)=0;
        end
        SB(i+3)=gran(i+2)*w2_(train,i+2);   % S.C./B.C. is activated only by granule cells
        
        % P-cell and its noise ----------------
        pc(i+3)=capF(w1_(train,i+2)*gran(i+2)-SB(i+3)+inPc); % Purkinje cell 
                           % has two inputs regions: S.C./B.C. and granule cell
                           % capF is a function in another file that does
                           % not allow activity of a cell shoot over 1
        pc(i+3)=capF(1./(1+exp(-(pc(i+3)-.5)/.1))+r1(train,i)*0.1); %logistic noise 
        %       you can create your own functions for different noise types
        %         %uniform
        %         %bernoulli
        %         %beta function

        % DCN: one DCN nucleus activates red nucleus (dcn1), the other inhibits IO (dcn2)
        dcn1(i+4) = capF(inDcn-w_dcn*pc(i+3)); 
        dcn2(i+4) = capF(inDcn-w_dcn*pc(i+3)); 
        
        % RN and its noise ----------------
        rn(i+5) = dcn1(i+4);  % RN: activated by dcn1 (the DCN on the left in the circuit diagram)
        rn(i+5)=capF(1./(1+exp(-(rn(i+5)-.5)/.1))+r1(train,i)*0.1); %logistic noise
        %         %uniform
        %         %bernoulli
        %         %beta function
        
        % the climbing fiber and the inferior olive----------------
        % ******************************************************
        cf(train,i+4)= capF(.8*trig(i+2)-0.15*dcn2(i+2)+inIO); % the error corrector rule
                                                               % Play arround with the two
                                                               % coefficients
        % ******************************************************
        er_(train,i+4)= cf(train,i+4)-inIO; % the error: it can be negative or positive
                                            % positive during learning and
                                            % negative during extinction 
        w1_(train,i+5)= w1_(train,i+4) - eps1*gran(i+2)*(er_(train,i+4));
        w2_(train,i+5)= w2_(train,i+4) + eps2*gran(i+2)*(er_(train,i+4));
        w1_(train,i+5)= capF(w1_(train,i+5)); % make sure the weights do 
        w2_(train,i+5)= capF(w2_(train,i+5)); % not exceeds one 
    end % one trial ends here 
    
    % connecting next trial with the previous one-----------
    w1_(train+1,:)=w1_(train,len);
    w2_(train+1,:)=w2_(train,len);
    
%  Other error correcting mechanisms ----------------------
%     cs = CS(15);
%     error corrector rules (the output of IO)
%   (1)
%     er_(train)= -1;
%     if (trig(18)-dcn2(18))>=0
%         er_(train)=1;
%     end
%   (2)
%     er_(train) = trig(18)-0.5*dcn2(18); % unstable during learning
%   (3)
%     er_(train) = +0.25*trig(18)+trig(18)-0.25*(dcn2(18));
%   (4)
%     er_(train) = +2*(trig(18)+1/2);
 
%     w1_(train+1)=w1_(train)+ eps1*cs*(-er_(train));
%     if w1_(train+1)<0
%         w1_(train+1)=0;
%     end
%     w2_(train+1)=w2_(train)+ eps2*cs*(er_(train));
%     if w2_(train+1)<0
%         w2_(train+1)=0;
%     end

    bl_(train)=mot(CS_len+pad_len-2); % record the blink specificly two time steps right before
                                      % US occurs; change this if you want
                                      % a different definition of "blink"
    rn_(train)=max(rn); % record the max and min of rn and pc to the housekeep variables
    pc_(train)=min(pc); % you can play around what you want to actually record and plot
end
%% figures
figure(1) % P-cell, RN activities, and weights
plot(1:Ntrain,rn_,'g',1:Ntrain,pc_,'r',1:Ntrain,w1_(2:end,:),'.g',1:Ntrain,w2_(2:end,:),'.r')
legend('red neclues','P-cell','w_P-cell','w_SCBC')

figure(2) % performance which is usually measured by experimenters 
correctness=zeros(1,session);
for i=1:session
    correctness(i)=sum(bl_(1,trialPsession*(i-1)+1:trialPsession*i)>=blink_threshold);
end
plot(correctness,'o');
xlabel('session number')
ylabel('%CR')
ylim([0 100])
title('Performance','fontsize',12)

figure(3) % 
% the following code was written before the "change" switch was in place
% hold on
% [AX,H1,H2] = plotyy([1:Ntrain],w1_(2:end,len),[1:Ntrain],rn_,'plot');
% set(H2,'linestyle','-')
% % set(H2,'ytick',[1/3 2/3])
% xlabel('# training trial')
% set(get(AX(1),'Ylabel'),'string','synaptic weights') 
% set(get(AX(2),'Ylabel'),'string','Red Nucleus Activity')
% % set(get(AX(2),'Ylim'),[0,0.5])
% % set(get(AX(2),'yTickLabel'),{'-pi','-pi/2','0','pi/2','pi'})
% % set(get(AX(2),'Ytick'),[1/3 2/3])
% % title('Oscillation during US-CS paired trials','fontsize',12)
% % title('Extinction','fontsize',12)
% plot([1:Ntrain],w2_(2:end,len),'-.')
% legend('Granule -> P-cell','Granule -> S.C./B.C.')
% hold off
subplot(2,1,1) 
if US_switch==1
    plot([1:Ntrain],max(er_,[],2),'ro')
elseif US_switch==0
    plot([1:Ntrain],min(er_,[],2),'ro')
end
title('the Error Signal','fontsize',12)
xlabel('# training trial')
ylabel('the activity of climbing fiber')
subplot(2,1,2)
if US_switch==1
    plot([1:Ntrain],max(cf,[],2),'ro')
elseif US_switch==0
    plot([1:Ntrain],min(cf,[],2),'ro')
end
title('Climbing Fiber','fontsize',12)
xlabel('# training trial')
ylabel('the activity of climbing fiber')

figure(4) % temporal activities of each neuron/nucleus 
plot([1:len],dcn1,'r',[1:len],mot,'g',[1:len],pc,'k',[1:len],CS,'b',[1:len],trig,'b-.',[1:len],rn,'c',[1:len],US,'p',[1:len],cf(end,:),'m')
axis([1 len -0.2 1.3])
legend('dcn','mot','pc','CS','trig','rn','US','cf')
