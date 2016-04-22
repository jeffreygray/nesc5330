function TraceConditioningSpike
clear all;
more off;
tic %start chronometer

%%%%%
% code by Blake Thomas, June 3, 2010
% Kai Chang, William Levy
%%%%%

% All matricies are in format row = neuron, col = time

ni 		= 2000;    % num neurons
Activity 	= 0.06;   % desired network activity level
Con 		= 0.1;     % neuron interconnectivity
mu 		= 0.0005;  % synaptic modifcation rate constant
K0 		= 0.86;    % shunting rest conductance
epsilonK0       = 0.1;       % rate constant for delta-K0
KFB 	        = 0.043;    % feedback inhibition scaling constant
KFF 		= 0.0078;    % feedforward inhibition scaling constant
lambdaFB 	= 0.5;       % feedback interneuron synaptic modification rate
lambdaFF 	= 0;       % feedforward interneuron synaptic modification rate

Me 		= 64;          % number of neurons used in conditioning pattern
NumToFire 	= Activity*ni; % number of neurons firing on each timestep

synapmod 	= 1; 	% 1: turn on synaptic modifcation
competitive     = 0; 	% 1: turn on competitive inhibition
saveWeights     = 0;    % 1: save weights every trial THIS FILLS THE HARD-DRIVE
testing         = 0;    % bool flag for testing

%%% Time Settings in ms; these don't matter if you import everything from NJ
deltaT    = 10;          % milliseconds (ms) should divide evenly into 20ms
lenpreCS  = 0;          % length of pre-cs (fills the boxcar)
lenCS     = 100;         % Length of CS in ms
lenUS     = 100;         % Length of US in ms
lentrace  = 400;         % trace length in ms

NumTrials = 200; % number of times to run training trials

%%% Time Settings in TIMESTEPS
preCS     = lenpreCS/deltaT;
stutterCS = lenCS/deltaT;           % repitition of input patterns, Length of CS in ms
stutterUS = lenUS/deltaT;           % repitition of input patterns, Length of US in ms
trace     = lentrace/deltaT;        % trace length in timesteps

TrainTime = preCS + stutterCS + trace + stutterUS; % sequence depth for training
TestTime  = preCS + stutterCS + trace + stutterUS; % sequence depth for testing

%filter settings
filter		= 1; %1%boolean for using a filter
filterSize	= 2; %2% This must be rounded
filterDecay     = 0.25; %when a neuron fires, all elements in the filter are scaled by this number
filterVals	= [.5,.5;.5,.5]; %should be filterSize x filterSize so that you can make non-uniform filters.
%non-uniform filters have a certain rule see filterHelp.txt for detailsTr

SequenceDepth = TrainTime;

pathstring = './resultsSpike/';
mkdir(pathstring);

% create surface and US matrices
Totalsurface = zeros(NumTrials,TrainTime);
USactivity   = zeros(NumTrials,TrainTime);

k0tracker    = zeros(NumTrials,1);
k0erftracker = zeros(NumTrials,1);
ActTracker   = zeros(NumTrials,1);

% create special data collection matrices for finding boxcar distributions
%Z0savedExcitations = zeros(ni, boxcarSize, NumTrials);

% load or create weight and connection matricies
% [FanInCon, cInMatrix, wInMatrix] = CreateNetwork(ni, Con, wStart, wDist, wLow, wHigh);
[FanInCon, cInMatrix, wInMatrix] = CreateNetwork(ni, Con, 0.4, 0);

fbWeightList = ones(1,ni);
fbWeightMatrix = zeros(TrainTime,ni);

%disp('Begin Training');
for counttrials = 1:NumTrials %counttrials = 1;

  if (counttrials > NumTrials) % if last run test instead of train
	Inputs = TestSeq;
	SequenceDepth = TestTime;
	synapmod = 0;  %no synaptic modification during testing
	testing = 1;
  end
  
  tcount = 1; % counter tracks time

  % load or create static Z0
  Z0 = zeros(1,ni);
  Z0fired = []; 

  %%%Load inputs that NJ used 
  Inputs = load(['inputs/TrainSeq_',num2str(counttrials),'.dat'])';

  Z = zeros(ni, SequenceDepth); %clear Z, the firing pattern matrix
%  Zbar = zeros(ni,1); %now we are NOT storing all Zbars
%  prevZbar = zeros(ni,1); %now we are storing the Zbar of synapse i when it gets activated the next time.
%  timeSinceFired = ones(ni,1)*(TrainTime+1); 
%  firstAct       = zeros(ni,1) .- (2 * rise); %this will be used if a neuron fires twice during a rise (rise must be > 2 in this case)
%  riseUntil      = zeros(ni,1); %needed for zBar
%  timeSinceFired(Z0fired) = 0;  %the Z0's fired.
  excitation = zeros(ni, 1); 
  %clear saved excitations
  savedexcitation = zeros(ni, filterSize);
  savedinhibition = zeros(1, filterSize);

  if(competitive == 1)
    for i = 1:ni        
         excitation(i) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Z0', 2);
    end
    % Competitively select which neurons fire
    Z(:,1) =  CompetitiveInhibition( excitation, Z(:,1), ni, NumToFire);
  else 
    savedinhibition(mod(tcount, filterSize)+1) = CalcInhibition(Inputs(:,1), fbWeightList, Z0', ni, 2, K0, KFB, KFF);
    if (filter)

     for i = 1:ni  
	   savedexcitation(i,mod(tcount,filterSize)+1) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Z0', 2);%save the excitation
	   yj(i) = savedexcitation(i,:) * filterVals(:,mod(tcount,filterSize)+1) / ((savedexcitation(i,:) * filterVals(:,mod(tcount,filterSize)+1)) + (savedinhibition * filterVals(:,mod(tcount,filterSize)+1))  ); 
     end%for ni
     
     Z(:,1) = ((yj' >= 0.5) | Inputs(:,1) );
     savedexcitation -= repmat(Z(:,1),1,filterSize) .* savedexcitation * (1-filterDecay);

    else%if filter
     for i = 1:ni
      excitation(i) = CalcExcitationWithInhibition(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Inputs(:,1), fbWeightList, Z0', ni, 2, K0, KFB, KFF);
     end %for ni     
% Network is free-running, so all neurons which reach threshold may fire  

     Z(:,1) = ((excitation >= 0.5) | (Inputs(:,1)) );
    end%if filter


    %Daves Rule:
    fbWeightList = DavesRule(Z0, sum(Z(:,tcount)), fbWeightList, lambdaFB, Activity, ni);
    %Get rid of negative weights
    fbWeightList = fbWeightList .* (fbWeightList > 0 );
    fbWeightMatrix(1,:) = fbWeightList;

  end %if competitive
  
  % Perform similar calculations for all future timesteps, but using Z(t-1)
  % instead of Z0
  for k = 2:SequenceDepth
     tcount = tcount+1; 	%time advances to the present
     
   %  Z(:, tcount) = Inputs(:,k);	%external inputs are introduced
	if(competitive == 1)
        %loop to do weighted summation to find excitation
        	for i = 1:ni             
        	    excitation(i) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Z, tcount);
        	end
        % Handle competitive inhibition 
      		Z(:,tcount) =  CompetitiveInhibition(excitation, Z(:,tcount), ni, NumToFire); 
     	else
         savedinhibition(mod(tcount, filterSize)+1) = CalcInhibition(Inputs(:,k), fbWeightList, Z, ni, tcount, K0, KFB, KFF);
   

	if (filter)
	   for i = 1:ni  
	    savedexcitation(i,mod(tcount,filterSize)+1) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Z, tcount);%save the excitation
	   yj(i) = savedexcitation(i,:) * filterVals(:,mod(tcount,filterSize)+1) / ((savedexcitation(i,:) * filterVals(:,mod(tcount,filterSize)+1)) + (savedinhibition * filterVals(:,mod(tcount,filterSize)+1))  ); 
	   end % for

%size(savedexcitation)
%size(Z(:,tcount))
%size(repmat(Z(:,tcount),1,filterSize))
%size(yj)

         Z(:,tcount) = ((yj' >= 0.5) | Inputs(:,tcount) );

         savedexcitation -= repmat(Z(:,tcount),1,filterSize) .* savedexcitation * (1-filterDecay);
	
	else%if filter
         for i = 1:ni  
          excitation(i) = CalcExcitationWithInhibition(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Inputs(:,k), fbWeightList, Z, ni, tcount, K0, KFB, KFF);  
	 end % for
         Z(:,tcount) = ((excitation >= 0.5) | Inputs(:,tcount) );

	end%if filter
		%Daves Rule:
		fbWeightList = DavesRule(Z(:,tcount-1)', sum(Z(:,tcount)), fbWeightList, lambdaFB, Activity, ni) ;
		fbWeightList = fbWeightList .* (fbWeightList > 0 );%Get rid of negative weights
        	fbWeightMatrix(tcount,:) = fbWeightList; 
	end

  end% for sequence depth

  
  %update weights using spikeTiming.m rule
  if ( mu > 0)
   wInMatrix = spikeTiming(cInMatrix, wInMatrix, Z, mu, deltaT);
  end

  %Store both surfaces
			%not first trial, add to next row
	USact = sum( Z( Me+1:Me+Me,:) ) / Me;		%average activity for US neurons
	Totalsurface(counttrials,:) = sum(Z)/ni;	%activity for entire network
	USactivity(counttrials,:) = USact;	

  %Save firing matrix Z
  if counttrials > NumTrials
	save([pathstring,'/testing_' ,num2str(counttrials),'.mat'], 'Z')
  else
	save([pathstring,'/training_',num2str(counttrials),'.mat'], 'Z')
  end

  %Save Weights Every Trial
  if (saveWeights == 1)
     save(['Trace', int2str(trace) ,'_delT', int2str(deltaT), '_weights_iteration',num2str(counttrials),'.mat'],'wInMatrix')
  end

  %Store K0, Activity
  k0tracker(counttrials) = K0;
  trialactivity = sum(sum(Z))/(ni*TrainTime);
  ActTracker(counttrials)= trialactivity;

  %Modify K0
  deltaK0    = epsilonK0 * (trialactivity - Activity);
  K0         = K0 + deltaK0;

end

%Save the created surfaces/histories
save([pathstring, '/Trace', int2str(trace) ,'_delT', int2str(deltaT), '_surface.mat'     ],'Totalsurface')
save([pathstring, '/Trace', int2str(trace) ,'_delT', int2str(deltaT), '_USactivity.mat'  ],'USactivity')
save([pathstring, '/Trace', int2str(trace) ,'_delT', int2str(deltaT), '_K0history.mat'   ],'k0tracker')	
save([pathstring, '/Trace', int2str(trace) ,'_delT', int2str(deltaT), '_Acthistory.mat'  ],'ActTracker')
save([pathstring, '/Trace', int2str(trace) ,'_delT', int2str(deltaT), '_finalweights.mat'],'wInMatrix')

'TraceConditioning Complete.'
toc %show elapsed time
