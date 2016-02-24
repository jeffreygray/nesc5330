
 %% clears previous run data and figures
%clear all
%close all
init_length = 9;        % No US or CS input (Prevents out of bounds errors 
                         % during callbacks)
CS_length = 10;         % Duration of CS input
US_length = 15;         % Duration of US input  
end_length = 10;        % No CS or US input, used for plotting
sessions = 110;         % Number of training sessions
trialsPerSession = 15;  % Number of trials per session
CS_on = 0;              % Determines if trial will have CS input            
US_on = 0;              % Determines if trial will have US input
trace = 1;             % Trace period 
learning = 1;           % Trial to start learning
extinction = 1201;      % Trial to start extinction
relearning = 20001;     % Trial to start learning after extinction  
                           
%% constants
% time constants
e_Purk = 0.0005;      % for granule-Purkinje synapses
e_SCBC = 0.0005;      % for granule-SCBC synapses

% initial weights----------------
w_Purk = 0.55;
w_SCBC = 0.45;

% internal excitations (spontaneous firing rates)----------------
inPurk = .5;    % the purkinje cell Spontaneous 50 spikes/sec (Maiz et al., 2012)
inDCN = 1;      % the deep nucleus
inIO = 0.005;   % the inferior olive: IO has a spontaneous firing rate about 1Hz (Simpson et al., 1996)
                  % but has maximum firing rate around 200Hz, so the relative
                  % activity during spontaneous firing is 1Hz/200Hz=0.005
eqIO = .005;    %inferior olive activity at overtraining equillibrium (15Hz/200Hz = .075)

% weights that do not change-----------
w_DCN = 1/inPurk;  % Ensures DCN activity goes to 0 as (DCN activity = DCN - Purk*w_DCN) --See line 159
mot_0=.3; mot_1=.6; % these two parameters define how the activity of the muscle
                    % carries on to the next timestep. 
                    % "mot" stands for both the activity of the muscle that releases the nictitating membrane
                    % and the activity of accessory abducens nucleus 

% thresholds--------------
blink_threshold = .2; % required level of muscle activity needed to trigger blink response

%% initializations
% setup US, CS, and time vectors-------
[CS, US] =CSUS(init_length,CS_length,US_length,end_length,CS_on,US_on,trace_on);
timesteps = length(CS); %number of timesteps in a given trial
totalTrials = sessions*trialsPerSession; % the total number of training trials

% initializations of relevant brain activity over total time interval
mot = zeros(1,timesteps);              % blink muscle and acessory abducens nucleus
dist = zeros(1, timesteps);            % distance covered by the nictitating membrane (continuous model)
trig = zeros(1,timesteps);             % spinal trigeminal
bl = zeros(1,timesteps);               % blink
pont = zeros(1,timesteps);             % pontine nucleus
gran = zeros(1,timesteps);             % granule cells
SB = zeros(1,timesteps);               % SC/BC Cells
purk = ones(1,timesteps)*inPurk;       % spontaneous activity of Purkinje Cells 
dcn1 = inDCN-w_DCN*purk;               % deep cerebellar nucleus: (2 different cells) -Cannot be negative
dcn2 = inDCN-w_DCN*purk;               % deep cerebellar nucleus: (2 different cells) -Cannot be negative
rn = zeros(1,timesteps);               % red nucleus
err = zeros(1,timesteps);              % Error for synaptic modifications
cf = ones(totalTrials,timesteps)*inIO; % spontaneous activity of climbing fibers

% weights
w1_=zeros(totalTrials,timesteps); % weights matrix for Granule-Purkinje synapse
w2_=zeros(totalTrials,timesteps); % weights matrix for Granule-SCBC synapse
w1_(1,:)=w_Purk;            
w2_(1,:)=w_SCBC;

%These parameters with a '_' after them are used to record the
%values given over the entire simulation.  Used as reference and in
%plotting data at the end.  
err_=zeros(totalTrials,timesteps);
rn_=zeros(1,totalTrials);
cf_=zeros(1,totalTrials);
purk_=zeros(1,totalTrials);
bl_=zeros(1,totalTrials);
DCN = zeros(0);
MOT = zeros(0);
DIST = zeros(0);
TRIG = zeros(0);
RN = zeros(0);
PURK= zeros(0);
PURKC = zeros(0);
% other parameters
counter = 0;
partblink = 0;
tot = zeros(1,sessions+1);
Pnoise = 0; 
Rnoise = 0;

%% simulation
% random number generations for the noise -------------------
rng(158); % try different seeds
r1=rand(totalTrials,timesteps);
rng(1260);
r2=rand(totalTrials,timesteps);
betaOn = makedist('Beta', 'a', 16, 'b', 4);
betaOff = makedist('Beta', 'a', 4, 'b', 16);
%---------Training-------------------------------------------
for trial=1:totalTrials 
    
    %pre-session, extinction, and relearning
    if trial == learning
        US_on = 1;
        CS_on = 1;
        [CS, US] = CSUS(init_length,CS_length,US_length,end_length,CS_on,US_on,trace_on);
    end
    if trial == extinction
        US_on = 0;
        [CS, US] = CSUS(init_length,CS_length,US_length,end_length,CS_on,US_on,trace_on);
    end
    if trial == relearning
        US_on = 1;
        [CS, US] = CSUS(init_length,CS_length,US_length,end_length,CS_on,US_on,trace_on);
    end
    
    %Learning
    for i=1:timesteps-5 % -5 because the largest offset of i is +5 (+5 for RN)
        
        %CS-induced
        pont(i+1)=CS(i);                    % pontine nucleus: activated by CS and shifted down 1 time-step
        gran(i+2)=(pont(i)>0)*(random(betaOn, 1))+(pont(i) == 0)*(random(betaOff, 1));                % granule cell is activated by potine nucleus
        SB(i+3)=gran(i+2)*w2_(trial, i+2);  % S.C./B.C. is activated only by granule cells
            %Purkinje Cells
            purk(i+3)=capF(w1_(trial, i+2)*gran(i+2)-SB(i+3)+inPurk);
                % Purkinje cell has two inputs regions: 
                  % S.C./B.C. and granule cell. S.C./B.C. inhibition is very
                  % fast, thus it does not take a timestep.
                % capF is an external function that does not
                  % allow cell activity to exceed 1 or be negative                                                                                                   
            Pnoise = .125*(.5 - 1/(1+exp(10*r1(trial, i) -5)));  
            purk(i+3) = capF(purk(i+3)) + Pnoise;                                                                  
            % DCN 
            dcn1(i+4) = capF(inDCN-w_DCN*purk(i+3)); % one DCN nucleus activates red nucleus
            dcn2(i+4) = capF(inDCN-w_DCN*purk(i+3)); % the other inhibits IO.  
                                                     % Both activate onl0y when purkinje inhibiton 
                                                     % becomes less than spontaneous DCN activity
            % Red Nucleus
            Rnoise = .125*(.5 - 1/(1+exp(10*r2(trial, i) -5))); 
            rn(i+5) = dcn1(i+4);  % RN: activated by dcn1 
            rn(i+5)=rn(i+5) + Rnoise;
            
        %US-induced
        
        %continuous model (takes into account partial blinking)    
            dist(i) = 1/(1+exp(-6*mot(i)+3));
            partblink = dist(i);
            partblink = 0;
        %Thresholded model
            %partblink = mot(i) >= blink_threshold;
        trig(i+1)=US(i)*(1-partblink);                           % spinal trigeminal: 
                                                                   % activated by US but blink blocks US
        mot(i+2)=errcapF(mot_1*(rn(i+1)+trig(i+1))+mot_0*mot(i+1)); % abducens nucleus and retractor bulbi: 
                                                                   % recieves input from red nucleus 
                                                                   % (CS), spinal trigeminal (US), and 
                                                                   % previous activity. 
        %Climbing Fiber and Inferior Olive
        cf(trial,i+2) = errcapF(.7*trig(i+1)-2*dcn2(i+1)+inIO); % climbing fiber activity is sum of 
                                                                  % excitatory and inhibitory inputs 
        err_(trial,i+2) = cf(trial,i+2)-eqIO;                   % error: is negative during learning, 
                                                                  % positive during extinction
                                                                    
        %Error corrected synaptic modification (capF caps weights at 1)
        w1_(trial,i+3)= capF(w1_(trial,i+2) - e_Purk*gran(i+2)*(err_(trial,i+2)));
        w2_(trial,i+3)= capF(w2_(trial,i+2) + e_SCBC*gran(i+2)*(err_(trial,i+2)));
        
        session = floor(trial/100)+1;         % sessions are dividing into groups of 100 training trials
        tot(session) = sum(mot)+tot(session); % sums total muscle activity per session 
    end 
  
    % connecting next trial with the previous one-----------
    w1_(trial, timesteps-1:timesteps) = w1_(trial,timesteps-2); % sets weights of last two timesteps to be same as 
    w2_(trial, timesteps-1:timesteps) = w2_(trial,timesteps-2);   % last recorded value
    w1_(trial+1,:) = w1_(trial,timesteps-2);                    % sets last recorded weight to be baseline 
    w2_(trial+1,:) = w2_(trial,timesteps-2);                      % for next trial

    bl_(trial)=mot(CS_length+init_length-US_length); % record motor activity at time that would imply CR success
                                                       % (i.e. predicting and blocking the air puff)
    DCN = [DCN; dcn2];
    MOT = [MOT; mot];
    DIST = [DIST; dist];
    TRIG = [TRIG; trig];
    RN = [RN; rn];
    PURK = [PURK; purk];
    % Houskeeping variables used for plots below
    rn_(trial)=max(rn);                              
    purk_(trial)=min(purk);                            
end
tot = tot./100;

%% figures
%-------------------------------------------------------
%-----P-cell, RN activities, and respective weights-----
%-------------------------------------------------------
figure() 
plot(1:totalTrials,rn_,'g',1:totalTrials,purk_,'r',1:totalTrials,w1_(2:end,:),'.g',1:totalTrials,w2_(2:end,:),'.r')
legend('red nucleus','P-cell','w_P-cell','w_SCBC')
xlabel('trial number');
ylabel('weight magnitude');
title('P-Cell, Red Nucleus, and Weights');
%-------------------------------------------------------
%-------------Conditioned Response Rate-----------------
%-------------------------------------------------------
figure() 
correctness=zeros(1,sessions);
for i=1:sessions
    % sums succesful blinks (indicated by a 1) over trials 1-100, 101-200, etc. 
    correctness(i)=sum(bl_(1,trialsPerSession*(i-1)+1:trialsPerSession*i)>=blink_threshold); 
end
plot(correctness,'-');
xlabel('session number')
ylabel('%CR')
ylim([0 100])
title('Performance','fontsize',12)
%-------------------------------------------------------
%-------Climbing Fiber and Error Signal Activity--------
%-------------------------------------------------------
figure();
subplot(2,1,1) 
if US_on==1
    plot([1:totalTrials],max(err_,[],2),'ro')
elseif US_on==0
    plot([1:totalTrials],min(err_,[],2),'ro')
end
title('the Error Signal','fontsize',12)
xlabel('# training trial')
ylabel('the activity of climbing fiber')
subplot(2,1,2)
if US_on==1
    plot([1:totalTrials],max(cf,[],2),'ro')
elseif US_on==0
    plot([1:totalTrials],min(cf,[],2),'ro')
end
title('Climbing Fiber','fontsize',12)
xlabel('# training trial')
ylabel('the activity of climbing fiber')
%------------------------------------------------------
%------Temporal activities of each neuron/nucleus------
%------------------------------------------------------
figure()  
plot([1:timesteps],dcn1,'r',[1:timesteps],mot,'g',[1:timesteps],purk,'k',[1:timesteps],CS,'b',[1:timesteps],trig,'b-.',[1:timesteps],rn,'c',[1:timesteps],US,'p',[1:timesteps],cf(end,:),'m')
axis([1 timesteps -0.2 1.3])
legend('dcn','mot','pc','CS','trig','rn','US','cf')
