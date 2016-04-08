function TraceConditioning
clear all;
more off;
t1 = cputime;
tic %start chronometer

%%%%%
% code by Blake Thomas, April 17, 2012
% Kai Chang, William Levy
%%%%%

% All matricies are in format row = neuron, col = time

seed        = 1010; % seed the RNG
rng(seed);

ni          = 1000;    % num neurons
Activity 	= 0.1;   % desired network activity level
Con 		= 0.1;     % neuron interconnectivity
wStart      = 0.4;   % all weights start at 0.4
wDist       = 0;
mu          = 0.00175;  % synaptic modifcation rate constant
K0          = .68;    % shunting rest conductance
epsilonK0   = 0.1;       % rate constant for delta-K0
KFB 	    = 0.047;    % feedback inhibition scaling constant
KFF 		= 0.013;    % feedforward inhibition scaling constant
lambdaFB 	= 0.5;       % feedback interneuron synaptic modification rate
lambdaFF 	= 0;       % feedforward interneuron synaptic modification rate

Me          = 40;          % number of neurons used in conditioning pattern
NumToFire 	= Activity*ni; % number of neurons firing on each timestep

synapmod 	= 1; 	% 1: turn on synaptic modifcation
competitive = 0; 	% 1: turn on competitive inhibition
saveWeights = 0;    % 1: save weights every trial THIS FILLS THE HARD-DRIVE
testing     = 0;    % bool flag for testing

%%% Time Settings in ms; these don't matter if you import everything from NJ
deltaT    = 20;          % milliseconds (ms) should divide evenly into 20ms
lenpreCS  = 0;          % length of pre-cs (fills the boxcar)
lenCS     = 100;         % Length of CS in ms
lenUS     = 100;         % Length of US in ms
lentrace  = 500;         % trace length in ms

NumTrials = 150; % number of times to run training trials

%%% Time Settings in TIMESTEPS
preCS     = lenpreCS/deltaT;
stutterCS = lenCS/deltaT;           % repitition of input patterns, Length of CS in ms
stutterUS = lenUS/deltaT;           % repitition of input patterns, Length of US in ms
trace     = lentrace/deltaT;        % trace length in timesteps

TrainTime = preCS + stutterCS + trace + stutterUS; % sequence depth for training
TestTime  = preCS + stutterCS + trace + stutterUS; % sequence depth for testing

% create inputsequences (for now only one - based on Tutorial2's)
 TrainSeq                                                    = zeros(ni, TrainTime); % create sequence of zeros
 TrainSeq(1:Me      , (preCS+1):(preCS+stutterCS))           = 1;                    % add tone
 TrainSeq(Me+1:Me+Me, (TrainTime-(stutterUS-1)):TrainTime)   = 1;                    % add puff 
 TestSeq                                                     = zeros(ni, TestTime); 	% create sequence of zeros
 TestSeq(1:Me, (preCS+1):(preCS+stutterCS))                  = 1;			     	% add tone, NO PUFF

%NMDA Settings
lenrise   	= 20;          % NMDArise time in ms
rise      	= lenrise/deltaT;           % NMDArise
riseShape   = [0, 1]; %this has rise+1 values.
alphaFold 	= 80;         % e-fold decay time in ms
alpha     	= exp(-deltaT/alphaFold); % exp(-deltaT / 100ms) for 100ms e-fold decay

%filter settings
filter		= 0; %1%boolean for using a filter
filterSize	= 2; %2% This must be rounded
filterDecay = 1; %when a neuron fires, all elements in the filter are scaled by this number
filterVals	= [.5,.5;.5,.5]; %should be filterSize x filterSize so that you can make non-uniform filters.
INfilterSize	= 2;
INfilterVals	= [.5,.5;.5,.5];
%non-uniform filters have a certain rule see filterHelp.txt for details

SequenceDepth = TrainTime;

pathstring = './results/';
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
[FanInCon, cInMatrix, wInMatrix] = CreateNetwork(ni, Con, wStart, wDist);

fbWeightList = ones(1,ni);
fbWeightMatrix = zeros(TrainTime,ni);

%disp('Begin Training');
for counttrials = 1:(NumTrials+1) %counttrials = 1;

    Inputs = TrainSeq;
  
  if (counttrials > NumTrials) % if last run test instead of train
	Inputs = TestSeq;
	SequenceDepth = TestTime;
	synapmod = 0;  %no synaptic modification during testing
	testing = 1;
  end
  
  tcount = 1; % counter tracks time

  % load or create static Z0
  Z0 = zeros(1,ni);
  Z0 = CreateZ0(ni, Activity, Me);
  Z0fired = Z0(1:(ni*Activity),2);
  Z0 = spconvert(Z0);
  for t = 1:ni
     if( Z0(t) == 2) 
        Z0(t)=1;
     end
  end

  Z = zeros(ni, SequenceDepth); %clear Z, the firing pattern matrix
  Zbar = zeros(ni,1); %now we are NOT storing all Zbars
  prevZbar = zeros(ni,1); %now we are storing the Zbar of synapse i when it gets activated the next time.
  timeSinceFired = ones(ni,1)*(TrainTime+1); 
  firstAct       = zeros(ni,1) - (2 * rise); %this will be used if a neuron fires twice during a rise (rise must be > 2 in this case)
  riseUntil      = zeros(ni,1); %needed for zBar
  timeSinceFired(Z0fired) = 0;  %the Z0's fired.
  excitation = zeros(ni, 1); 
  %clear saved excitations
  savedexcitation = zeros(ni, filterSize);
  savedinhibition = zeros(1,  INfilterSize);
  % Calculate excitation

  if(competitive == 1)
    for i = 1:ni        
         excitation(i) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Z0', 2);
    end
    % Competitively select which neurons fire
    Z(:,1) =  CompetitiveInhibition( excitation, Z(:,1), ni, NumToFire);
  else 
    if (filter) 
	savedinhibition(2) = CalcInhibition(Inputs(:,1), fbWeightList, Z0', ni, 2, K0, KFB, KFF);
    end%if
    for i = 1:ni
	if (filter)
	   savedexcitation(i,mod(tcount,filterSize)+1) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Z0', 2);%save the excitation
	   yj = savedexcitation(i,:) * filterVals(:,mod(tcount,filterSize)+1) / ((savedexcitation(i,:) * filterVals(:,mod(tcount,filterSize)+1)) + (savedinhibition * INfilterVals(:,2) )); 
	   yjs( i, tcount, counttrials) = yj;
	   if( yj >= 0.5 || Inputs(i,1) == 1) 
	   	Z(i,1) = 1;
	   	if( (rise > 0) && (timeSinceFired(i) < rise) ) %fired on a rise, need to keep track of stuff to get zbar correct
		  if ( tcount - firstAct(i) > rise ) %need to set firstAct
		    firstAct(i) = tcount - timeSinceFired(i);
		  else %second (or third..) fire on this rise need to set this so zbar stays saturated once it hits 1.
		    riseUntil(i) = tcount+rise;
		  end%if
	   	end%if
	   	timeSinceFired(i) = 0;
		savedexcitation(i,:) = savedexcitation(i,:) * filterDecay;
	   else %don't fire
	   	Z(i,1) = 0;
	   	timeSinceFired(i) = timeSinceFired(i)+1;
	   end%if excitation

	else%if filter
	 excitation(i) = CalcExcitationWithInhibition(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Inputs(:,1), fbWeightList, Z0', ni, 2, K0, KFB, KFF);
	% Network is free-running, so all neurons which reach threshold may fire  
	 if( excitation(i) >= 0.5 || Inputs(i,1) == 1) 
	   Z(i,1) = 1;
	   if( (rise > 0) && (timeSinceFired(i) < rise) ) %fired on a rise, need to keep track of stuff to get zbar correct
		if ( tcount - firstAct(i) > rise ) %need to set firstAct
		  firstAct(i) = tcount - timeSinceFired(i);
		else %need to set this so zbar stays saturated.
		  riseUntil(i) = tcount+rise;
		end%if
	   end%if
	   timeSinceFired(i) = 0;
	 else %don't fire
	   Z(i,1) = 0;
	   timeSinceFired(i) = timeSinceFired(i)+1;
	 end%if excitation
	end%if filter
    end%for ni

    %Daves Rule:
    fbWeightList = DavesRule(Z0, sum(Z(:,tcount)), fbWeightList, lambdaFB, Activity, ni);
    %Get rid of negative weights
    fbWeightList = fbWeightList .* (fbWeightList > 0 );
    fbWeightMatrix(1,:) = fbWeightList;

  end %if competitive

% Perform synaptic modification if desired
  if (synapmod == 1)
	if (rise == 0)
	   Zbar = Z0'; %else Zbar is all zeros.
	end
	for post = 1:ni
	  wInMatrix(post,1:FanInCon(post)) = UpdateWeights( Z(post,tcount), Zbar(cInMatrix(post,1:FanInCon(post))+1)', wInMatrix(post,1:FanInCon(post)), mu);
	end
  end
  
  % Perform similar calculations for all future timesteps, but using Z(t-1)
  % instead of Z0
  for k = 2:SequenceDepth
     tcount = tcount+1; 	%time advances to the present
     
     if (synapmod == 1) %has to be done now because Zbar depends on when i fires!    
	%timeSinceFired
	Zbar = CalculateZbar( Z, prevZbar, tcount-1, alpha, ni, rise, timeSinceFired, firstAct, riseUntil, riseShape);  
     end

     Z(:, tcount) = Inputs(:,k);	%external inputs are introduced
	if(competitive == 1)
        %loop to do weighted summation to find excitation
        	for i = 1:ni             
        	    excitation(i) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Z, tcount);
        	end
        % Handle competitive inhibition 
      		Z(:,tcount) =  CompetitiveInhibition(excitation, Z(:,tcount), ni, NumToFire); 
     	else
	   if (filter) savedinhibition(mod(tcount,filterSize)+1) = CalcInhibition(Inputs(:,k), fbWeightList, Z, ni, tcount, K0, KFB, KFF); end;   
	   for i = 1:ni  

	if (filter)
	   savedexcitation(i,mod(tcount,filterSize)+1) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Z, tcount);%save the excitation
	   yj = savedexcitation(i,:) * filterVals(:,mod(tcount,filterSize)+1) / ((savedexcitation(i,:) * filterVals(:,mod(tcount,filterSize)+1)) + (savedinhibition * INfilterVals(:,mod(tcount,INfilterSize)+1) )); 
	   yjs( i, tcount, counttrials) = yj;
	   if( yj >= 0.5 || Inputs(i,tcount) == 1) 
	   	Z(i,tcount) = 1;
	   	if( (rise > 0) && (timeSinceFired(i) < rise) ) %fired on a rise, need to keep track of stuff to get zbar correct
		  if ( tcount - firstAct(i) > rise ) %need to set firstAct
		    firstAct(i) = tcount - timeSinceFired(i);
		  else %need to set this so zbar stays saturated.
		    riseUntil(i) = tcount+rise;
		  end%if
	   	end%if
	   	timeSinceFired(i) = 0;
		savedexcitation(i,:) = savedexcitation(i,:) * filterDecay;
	   else %don't fire
	   	Z(i,tcount) = 0;
	   	timeSinceFired(i) = timeSinceFired(i)+1;
	   end%if excitation

	else%if filter
             excitation(i) = CalcExcitationWithInhibition(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Inputs(:,k), fbWeightList, Z, ni, tcount, K0, KFB, KFF); 
        	    if( excitation(i) >= 0.5  || Inputs(i,tcount) == 1) 
			 Z(i,tcount) = 1;
			   if( (rise > 0) && (timeSinceFired(i) < rise) ) %fired on a rise, need to keep track of stuff to get zbar correct
				if ( tcount - firstAct(i) > rise ) %need to set firstAct
				  firstAct(i) = tcount - timeSinceFired(i);
				else %need to set this so zbar stays saturated.
				  riseUntil(i) = tcount+rise;
				end%if
			   elseif (rise > 0) prevZbar(i) = Zbar(i);
			   end%if
			 timeSinceFired(i) = 0;
	     	    else Z(i,tcount) = 0;
       			 timeSinceFired(i) = timeSinceFired(i) + 1;
		    end
        	end
	end%if filter
		%Daves Rule:
		fbWeightList = DavesRule(Z(:,tcount-1)', sum(Z(:,tcount)), fbWeightList, lambdaFB, Activity, ni) ;
		fbWeightList = fbWeightList .* (fbWeightList > 0 );%Get rid of negative weights
        	fbWeightMatrix(tcount,:) = fbWeightList; 
	end

	% Perform synaptic modification if desired
	if (synapmod == 1)   
	  for post = 1:ni
		if (timeSinceFired(post) == 0)
		    wInMatrix(post,1:FanInCon(post)) = UpdateWeights( Z(post,tcount), Zbar(cInMatrix(post,1:FanInCon(post))+1), wInMatrix(post,1:FanInCon(post)), mu);
		end%if
	  end%for
	end%if
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
     save(['weights_iteration',num2str(counttrials),'.mat'],'wInMatrix')
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
save([pathstring, '/surface.mat'     ],'Totalsurface')
save([pathstring, '/USactivity.mat'  ],'USactivity')
save([pathstring, '/K0history.mat'   ],'k0tracker')	
save([pathstring, '/Acthistory.mat'  ],'ActTracker')
save([pathstring, '/finalweights.mat'],'wInMatrix')

disp('TraceConditioning Complete.');
toc %show elapsed time
t2 = cputime;
disp(['cpu cycles elapsed: ', num2str(t2-t1)]);
