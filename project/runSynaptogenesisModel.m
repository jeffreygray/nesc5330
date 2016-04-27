function [success] = runSynaptogenesisModel(proto)
%% FUNCTION Runs simulation of neurons using
% adaptive synaptogenesis by Adelsberger-Magnan and Levy
% Chris Kaylin & Blake Thomas, 2014
% modified by Harang Ju, 2015

tic

% --------------------
%%   Random Seeds
% --------------------

% Seed random number generator (rng), only for Matlab
% rng used for synaptogenesis (+ initial connections)
%     and input generation
seed = 9711963;
rng(seed);
% Use randomInputSeed for a separate rng for input generation
% randomInputSeed = 1;
% randomStream = RandStream.create('mt19937ar', 'Seed', randomInputSeed);

% --------------------
%%     Functions
% --------------------

% input function
% returns a block of input patterns
% column: an input pattern
% row: an input line
asciiLoad = load('ascii.mat');
% 9 is +
% 11 is 0
asciiInputs = repmat(asciiLoad.ascii(:, [9 11]), 1, 100);
function inputset = getInput
  % inputset = asciiInputs;
  % inputset = getInputs;
  inputset = proto;
end

% returns a batch of input blocks
BatchSize = 100;
function batchInput = getBatchInput(batchSize)
  [featureCount, inputPatternCount] = size(getInput);
  batchInput = zeros(featureCount, inputPatternCount * batchSize);
  for b = 1 : batchSize
    batchInput(:, (b-1)*inputPatternCount + 1 : b*inputPatternCount) = getInput;
  end
end

% --------------------
%%     Constants
% --------------------

disp('Setting parameters.');

Directory = 'results'; % to which to save results
NeuronCount = 8; % Number of output neurons
TotalPresentations = 20000; % max number of presentations of input blocks
PresentationsPerCycle = 1; % number of presentations of a given input block
CycleCount = floor(TotalPresentations / PresentationsPerCycle);
FireThreshold = 1.0;
ReceptivityThreshold = 0.1; % receptive to synaptogenesis
  % as long as activity < ReceptivityThreshold
AvidityCo = 0.001; % * 0.01;
Epsilon = 0.001; % learning constant of the synaptic modification rule
Gamma = 0.001; % constant of the probability of synaptogenesis
InitialWeightValue = 0.1; % value of the weight of new connections
WeightThreshold = 0.01; % connection gets deleted if the weight falls below 0.05
Alpha = 0.25;
RandConnectivity = 0.01;
StabilityThreshold = 200; % network stable after [threshold] cycles w/o changes in synapse count
BlockModificationOn = false;
RandomInitializationOn = false; % random initialization of weights
SheddingOn = true;
SynaptogenesisOn = true;
InitialSynapseCountPerNeuron = 1;
DisplayCycle = 50;
[FeatureCount, InputPatternCount] = size(getInput);

% --------------------
%%   Initialization
% --------------------

disp('Initializing variables.');

W = zeros(FeatureCount, NeuronCount); % the weight matrix
connectivity = zeros(FeatureCount, NeuronCount);
newConnectivity = zeros(FeatureCount, NeuronCount);
recentActivity = ReceptivityThreshold / 2 * ones(1, NeuronCount);
receptivity = zeros(1, NeuronCount);
avidity = zeros(FeatureCount, 1);
stabilityCount = 0;
deltaW = zeros(FeatureCount, NeuronCount);
connectedW = zeros(FeatureCount, NeuronCount);
newConnections = zeros(FeatureCount, NeuronCount);
shedConnections = zeros(FeatureCount, NeuronCount);
cycle = 1;
Ex = repmat(mean(getBatchInput(BatchSize), 2), 1, InputPatternCount);

% synaptogenesis & shedding data
synapseCount = zeros(NeuronCount, CycleCount);
synaptogenesisCount = zeros(NeuronCount, CycleCount);
synapticSheddingCount = zeros(NeuronCount, CycleCount);
meanPostExcitation = zeros(NeuronCount, CycleCount);
meanFiringsPerCycle = zeros(NeuronCount, CycleCount);
activityOverTime = zeros(NeuronCount, CycleCount);
synapseCountPresyn = zeros(FeatureCount, CycleCount);
firingsPresyn = zeros(FeatureCount, CycleCount);
connectionsAfterShedding = zeros(FeatureCount, NeuronCount);
weightLength = zeros(NeuronCount, CycleCount);

% initialize W with some random connections
for n = 1 : NeuronCount
  randpermFeatures = randperm(FeatureCount);
  connectivity(randpermFeatures(1:InitialSynapseCountPerNeuron), n) = 1;
end
W = InitialWeightValue .* connectivity(:, :);
newConnectivity = connectivity;

% Random weight initialization
if RandomInitializationOn
  W = (1 - WeightThreshold) * connectivity(:, :);
  W = W .* (rand(size(W)) + WeightThreshold);
end

% track synapse count
synapseCount(:, cycle) = sum(connectivity);
synapseCountPresyn(:, cycle) = sum(connectivity, 2);

% --------------------
%%  Begin simulation
% --------------------

disp('Started simulation.')

for cycle = 2 : CycleCount

  % ---------------------------------
  %      Update Stability Count
  % ---------------------------------

  stabilityCount = stabilityCount + 1;

  % ---------------------------------
  %           Get Inputs
  % ---------------------------------

  % get new inputs
  inputset = getInput;

  % calculate x_i - E[X] as "zeroCenteredInput"
  zeroCenteredInput = inputset - Ex;
  
  % ---------------------------------
  % Associative Synaptic Modification
  % ---------------------------------

  for presentation = 1 : PresentationsPerCycle

    % individual modification
    % update W for each prototype

    for inputPatternIndex = randperm(InputPatternCount)

      % Wpos = W - min(0, min(min(W)));
      Wexcite = W .* (W >= WeightThreshold);

      % get the postsynaptic excitation
      postsynExcitation = inputset(:, inputPatternIndex)' * Wexcite;
      % get (x_i - E[X_i] - w_i) as "presynTerm"
      presynTerm = repmat(zeroCenteredInput(:, inputPatternIndex), 1, NeuronCount) - W;
      % presynTerm = repmat(inputset(:, inputPatternIndex), 1, NeuronCount) - W;
      % get ∆w = e * y * (x_i - E[X_i] - w_i)
      deltaW = Epsilon * repmat(postsynExcitation, FeatureCount, 1) .* presynTerm;
      % update W with deltaW & keep ∆w's that have connections %
      W = W + deltaW .* connectivity;

    end % inputPatternIndex

  end % presentations loop

  % ---------------------------
  %        Track Data
  % ---------------------------

  z = inputset' * W > FireThreshold;
  recentActivity = (1 - Alpha) .* recentActivity + Alpha * mean(z);
  activityOverTime(:, cycle) = recentActivity;
  firingsPresyn(:, cycle) = synapseCountPresyn(:, cycle-1) .* sum(inputset, 2);
  meanFiringsPerCycle(:, cycle) = mean(z);
  meanPostExcitation(:, cycle) = postsynExcitation;

  % ---------------------------
  %     Synaptic Shedding
  % ---------------------------

  % get connections to shed that are already connected
  connectionsToShed = (W < WeightThreshold) & connectivity;
  % update connectivity (if shedding is turned on)
  connectivity = connectivity - (SheddingOn .* connectionsToShed);
  % update weights 
  W = W .* connectivity;
  % if a synapse was shed, reset stability count
  stabilityCount = stabilityCount * ~nnz(connectionsToShed);
  % track synaptic shedding
  synapticSheddingCount(:, cycle) = sum(connectionsToShed);
  
  % ---------------------------
  %    Check for Stability
  % ---------------------------

  % check to see if connections are stable
  if (stabilityCount > StabilityThreshold)
    break
  end

  % ---------------------------
  %       Synaptogenesis
  % ---------------------------

  % calculate receptivity
  receptivity = recentActivity < ReceptivityThreshold;
  % get probability of synaptogenesis
  pSynaptogenesis = repmat(Gamma * receptivity, FeatureCount, 1);
  % get new connections (that are not already connections)
  newConnections = pSynaptogenesis > rand(size(connectivity));
  % remove new connections if they are already connected (if synaptogenesis on)
  newConnections = SynaptogenesisOn .* newConnections & ~connectivity;
  % update connectivity (if synaptogenesis is on)
  connectivity = connectivity + newConnections;
  % update weights
  W = W + InitialWeightValue * newConnections;
  % if new connections made, reset stabilityCount
  stabilityCount = stabilityCount * ~nnz(newConnections);
  % track synaptogenesis
  synaptogenesisCount(:, cycle) = sum(newConnections);

  % ---------------------------
  %        Track Data
  % ---------------------------
  
  % track synapse count
  synapseCount(:, cycle) = sum(connectivity);
  synapseCountPresyn(:, cycle) = sum(connectivity, 2);

  % ---------------------------
  %        Display Data
  % ---------------------------  

  if mod(cycle, DisplayCycle) == 0
    imagesc(W); title(['cycle ', num2str(cycle)]);
    xlabel('neurons'); ylabel('input lines');
    colorbar; caxis([-0.1 0.1])
    pause(0.001);
  end

end % cycle

disp('Done.');

toc

% ---------------------------
%   Truncate & Save Data
% ---------------------------

disp('Saving data.');

if exist(Directory, 'dir') == 0
  mkdir(Directory);
elseif exist(Directory, 'dir') ~= 7
  disp([Directory, ' is not a directory. Change "Directory".']);
  return
end

synapseCount = synapseCount(:, 1:(cycle-1))';
synaptogenesisCount = synaptogenesisCount(:, 1:(cycle-1))';
synapticSheddingCount = synapticSheddingCount(:, 1:(cycle-1))';
activityOverTime = activityOverTime(:, 1:(cycle-1))';
meanFiringsPerCycle = meanFiringsPerCycle(:, 1:(cycle-1))';
synapseCountPresyn = synapseCountPresyn(:, 1:(cycle-1))';
firingsPresyn = firingsPresyn(:, 1:(cycle-1))';
meanPostExcitation = meanPostExcitation(:, 1:(cycle-1))';
weightLength = weightLength(:, 1:(cycle-1))';

% save data
save([Directory, '/', 'finalWeights.mat'], 'W');
save([Directory, '/', 'synapseCount.mat'], 'synapseCount');
save([Directory, '/', 'synaptogenesisCount.mat'], 'synaptogenesisCount');
save([Directory, '/', 'synapticSheddingCount.mat'], 'synapticSheddingCount');
save([Directory, '/', 'activityOverTime.mat'], 'activityOverTime');
save([Directory, '/', 'meanFiringsPerCycle.mat'], 'meanFiringsPerCycle');
save([Directory, '/', 'synapseCountPresyn.mat'], 'synapseCountPresyn');
save([Directory, '/', 'meanPostExcitation.mat'], 'meanPostExcitation');
save([Directory, '/', 'weightLength.mat'], 'weightLength');

disp(['Saved results to folder named "' Directory '"']);

success = mean(mutual(proto, W));
end
