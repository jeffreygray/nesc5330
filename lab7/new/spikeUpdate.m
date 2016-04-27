%
% spikeUpdate.m
%
% Most recent modifications by: Joseph Barrow (jdb7hw)
%
% New way to compute spike timing rule with weight updates. Make
% updates after every timestep, instead of after the entire trial.
%

function spikeUpdate

    clear all;
    more off;

    % Start chronometer
    t1 = cputime;
    tic;

    % Load the configuration file. Note that all matrices are now in
    % the form:
    %    row = neuron, col = time
    %
    ini = IniConfig();
    ini.ReadFile('./conf.ini');

    sections = ini.GetSections();
    [skeys, count_skeys] = ini.GetKeys(sections{1});
    [mkeys, count_mkeys] = ini.GetKeys(sections{2});

    % Load all the scalar (non-filter) values
    for n = 1:length(skeys)
        eval(sprintf('%s=%d;', skeys{n}, ini.GetValues(sections{1}, ...
            skeys{n})))
    end

    pathstring = ['results/test/seed/', num2str(seed), '/'];

    % Load all the matrices (filters) and reshape them into square
    % matrices
    filterVals = ini.GetValues(sections{2}, mkeys{1});
    filterVals = reshape(filterVals, [filterSize, filterSize]);

    % Set the seed for the RNG
    rng(seed);

    % Compute variables not set in ini file
    NumToFire = Activity * ni;
    stim = lenStimulus / deltaT;
    TrainTime = numPatterns * stim;
    TestTime = numPatterns * stim;

    TrainSeq = zeros(ni, TrainTime);
    TestSeq = zeros(ni, TestTime);

    % TODO
    % Refactor this into its own file, CreateSequences.m

    current = 1;
    for i = 1:numPatterns
        nstart = (i-1) * shift + 1;
        nstop  = nstart + Me - 1;
        tstart = (i-1) * stim + 1;
        tstop  = tstart + stim - 1;
        len = max(nstop - nstart + 1, tstop - tstop + 1);
        C = ones(len, 10);
        if(nstop - nstart > tstop - tstart)
            TrainSeq(nstart:nstop, tstart:tstop) = C(:, 1:(tstop-tstart)+1);
        else
            TrainSeq(nstart:nstop, tstart:tstop) = C(1:(nstop-nstart), :);
        end
    end %for i

    
    
    current = 1;
    for i = 1:numPatTest
        nstart = (i-1) * shift + 1;
        nstop  = nstart + Me - 1;
        tstart = (i-1) * stim + 1;
        tstop  = tstart + stim - 1;
        len = max(nstop - nstart + 1, tstop - tstop + 1);
        C = ones(len, 10);
        if(nstop - nstart > tstop - tstart)
            TestSeq(nstart:nstop, tstart:tstop) = C(:, 1:(tstop-tstart)+1);
        else
            TestSeq(nstart:nstop, tstart:tstop) = C(1:(nstop-nstart), :);
        end
    end %for i

    % nmda settings, MUST BE ZERO
    lenrise = 0;
    rise = lenrise/deltaT;
    alphaFold = 95;
    alpha = 0.95;

    % TODO
    % Make the nmda settings customizable in the ini file.

    SequenceDepth = TrainTime;

    % For more complex runs, be sure to change the pathstring to
    % something more complex.
    mkdir(pathstring);

    save([pathstring, 'TrainSeq.mat'], 'TrainSeq');
    save([pathstring, 'TestSeq.mat'], 'TestSeq');

    % Create surface and activity/K0 trackers
    Totalsurface = zeros(NumTrials, TrainTime);
    k0tracker = zeros(NumTrials, 1);
    ActTracker = zeros(NumTrials, 1);

    % Load or create weight and connection matrices
    %[FanInCon, cInMatrix, wInMatrix] = Fixedreadwij('wij.dat');
    % Alternatively, you can randomly create the matrices given the
    % seed you set previously:
    [FanInCon, cInMatrix, wInMatrix] = CreateNetwork(ni, Con, wStart, wDist);
    [RowIn, ColIn] = CreateSparseIndices(ni, Con, cInMatrix);
    [FanOutCon, cOutMatrix] = CreateFanOutCon(cInMatrix);
    [RowOut, idx] = sort(ColIn);
    ColOut = RowIn(idx);

    fbWeightList = ones(1, ni);

    disp('Begin Training:');
    for counttrials = 1:(NumTrials+1)
        Inputs = TrainSeq;

        disp(['Trial: ', num2str(counttrials)]);
        toc;

        if (counttrials > NumTrials)
            Inputs = TestSeq;
            SequenceDepth = TestTime;
            synapmod = 0;
            testing = 1;
        end

        % Counter keeping track of the time
        tcount = 1;

        % load or create static Z0
        Z0 = zeros(1, ni);
        Z0 = CreateZ0(ni, Activity, shift * numPatterns + Me);
        Z0fired = Z0(1:(ni*Activity),2);
        Z0 = spconvert(Z0);

        for t = 1:ni
            if( Z0(t) == 2)
                Z0(t) = 1;
            end
        end

        Z0 = zeros(1, ni);

        %full_z0 = full(Z0);
        %save(['results/z0_', num2str(counttrials), '.mat'], ...
        %    'full_z0');

        % Clear Z, the firing pattern matrix
        Z = zeros(ni, SequenceDepth);
        % Now we ARE storing all ZBars
        Zbar = zeros(ni, TrainTime);
        % No we are storing the ZBar of synapse i when it gets
        % activated the next time
        %prevZbar = zeros(ni, 1);
        timeSinceFired = ones(ni, 1) * (TrainTime + 1);
        % This will be used if a neuron fires twice during a rise (rise
        % must be > 2 in this case)
        firstAct = zeros(ni, 1) - (2 * rise);
        riseUntil = zeros(ni, 1);
        excitation = zeros(ni, 1);
        % Calculate excitation
        if(competitive == 1)
            for i = 1:ni
                excitation(i) = CalcExcitation(wInMatrix(i, 1:FanInCon(i)), ...
                    cInMatrix(i, 1:FanInCon(i))+1, Z0', 2);
            end
            % Competitively select which neurons fire
            Z(:,1) =  CompetitiveInhibition( excitation, Z(:,1), ni, ...
                NumToFire);
        else
            for i = 1:ni
                excitation(i) = CalcExcitationWithInhibition( ...
                    wInMatrix(i, 1:FanInCon(i)), ...
                    cInMatrix(i, 1:FanInCon(i))+1, ...
                    Inputs(:,1), fbWeightList, Z0', ni, 2, K0, KFB, KFF);
            end

            for i = 1:ni
                Z(i,1) = (excitation(i) >= 0.5) | Inputs(i,1);
            end

            timeSinceFired = (timeSinceFired + 1) .* (1 - Z(:,1));
        end

        fbWeightList = DavesRule(Z0, sum(Z(:,tcount)), fbWeightList, ...
            lambdaFB, Activity, ni);
        fbWeightList = fbWeightList - fbWeightList .* (fbWeightList < 0);
        % Perform synaptic modification if desired
        if (synapmod == 1)
            Zbar(:, 1) = Z0'; %else Zbar is all zeros.
            for post = 1:ni
                if(Z(post,1))
                    wInMatrix(post,1:FanInCon(post)) = ...
                        UpdateWeights( Z(post,tcount), ...
                        Zbar(cInMatrix(post,1:FanInCon(post))+1, 1)', ...
                        wInMatrix(post,1:FanInCon(post)), muRHS, 0);
                end
              end
              if (spikerule == 1)
                wOutMatrix = wInToOut(wInMatrix, RowIn, ColIn, ni, FanOutCon);
                for post = 1:ni
                    if(Z(post,1))
                        %wOutMatrix(post,1:FanOutCon(post)) = spikeTimingEps( ...
                        %    Z(cOutMatrix(post,1:FanOutCon(post))+1, 1:tcount), muSpike, epsFold, ...
                        %    wOutMatrix(post,1:FanOutCon(post)), lookback);
                        %wOutMatrix(post, 1:FanOutCon(post)) = spikeTiming( ...
                        %    Z(cOutMatrix(post,1:FanOutCon(post))+1, 1:tcount)', ...
                        %    Zbar(post, 1), Zbar(1:FanOutCon(post), 1)', ...
                        %    wOutMatrix(post,1:FanOutCon(post)), muSpike);
                        wOutMatrix(post, 1:FanOutCon(post)) = UpdateWeights( ...
                            Z(post,tcount), ...
                            Zbar(1:FanOutCon(post), 1)', ...
                            wOutMatrix(post, 1:FanOutCon(post)), muSpike, 1);
                    end
                end
                wInMatrix = wOutToIn(wOutMatrix, RowOut, ColOut, ni, FanInCon);
            end
        end

        % Perform similar calculations for all future timesteps, but using Z(t-1)
        % instead of Z0
        for k = 2:SequenceDepth
            tcount = tcount+1; 	%time advances to the present

            if (synapmod == 1) %has to be done now because Zbar depends on when i fires!
                Zbar(:, k) = CalculateZbar( Z, Zbar(:, k-1), tcount-1, alpha, ni, 0, timeSinceFired);
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
                for i = 1:ni
                    excitation(i) = CalcExcitationWithInhibition(wInMatrix(i, 1:FanInCon(i)), cInMatrix(i, 1:FanInCon(i))+1, Inputs(:,k), fbWeightList, Z, ni, tcount, K0, KFB, KFF);
                end

                Z(:,tcount) = Inputs(:,tcount) | ((excitation >= 0.5) & (timeSinceFired > 0));
                timeSinceFired = (timeSinceFired + 1) .* (1 - Z(:,tcount));
            end

            %save(['excitation_', num2str(counttrials), '_', num2str(k) '.mat'], 'excitation')

            fbWeightList = DavesRule(Z(:,tcount-1)', sum(Z(:,tcount)), fbWeightList, lambdaFB, Activity, ni);
            fbWeightList = fbWeightList - fbWeightList .* (fbWeightList < 0); %catch below zeros

            % Perform synaptic modification if desired
            if (synapmod == 1)
                for post = 1:ni
                    if (0 == timeSinceFired(post))
                        wInMatrix(post,1:FanInCon(post)) = UpdateWeights( ...
                            Z(post,tcount), ...
                            Zbar(cInMatrix(post,1:FanInCon(post))+1, k)', ...
                            wInMatrix(post,1:FanInCon(post)), muRHS, 0);
                    end
                end

                if (spikerule == 1)
                  wOutMatrix = wInToOut(wInMatrix, RowIn, ColIn, ni, FanOutCon);
                  for post = 1:ni
                      if (0 == timeSinceFired(post))
                          %wOutMatrix(post,1:FanOutCon(post)) = spikeTimingEps( ...
                          %    Z(cOutMatrix(post,1:FanOutCon(post))+1, 1:tcount), muSpike, epsFold, ...
                          %    wOutMatrix(post,1:FanOutCon(post)), lookback);
                          %wOutMatrix(post, 1:FanOutCon(post)) = spikeTiming( ...
                          %  Z(cOutMatrix(post,1:FanOutCon(post))+1, k)', ...
                          %  Zbar(post, k), Zbar(1:FanOutCon(post), k-1)', ...
                          %  wOutMatrix(post,1:FanOutCon(post)), muSpike);
                          wOutMatrix(post, 1:FanOutCon(post)) = UpdateWeights( ...
                            Z(post,k), ...
                            Zbar(1:FanOutCon(post), k)', ...
                            wOutMatrix(post, 1:FanOutCon(post)), muSpike, 1);
                        end %if
                    end % for
                    wInMatrix = wOutToIn(wOutMatrix, RowOut, ColOut, ni, FanInCon);
                end % if
            end % if
        end

        % Store both surfaces
        Totalsurface(counttrials,:) = sum(Z)/ni; %activity for entire network

        % Save firing matrix Z
        if counttrials > NumTrials
            save([pathstring,'/testing_' ,num2str(counttrials),'.mat'], 'Z');
        else
            save([pathstring,'/training_',num2str(counttrials),'.mat'], 'Z');
        end

        % Save Weights Every Trial
        if (saveWeights == 1)
            save([pathstring, '/weights_iteration',num2str(counttrials),'.mat'],'wInMatrix');
        end

        % Store K0, Activity
        k0tracker(counttrials) = K0;
        trialactivity = sum(sum(Z))/(ni*TrainTime);
        ActTracker(counttrials)= trialactivity;

        deltaK0    = epsilonK0 * (trialactivity - Activity);
        K0         = K0 + deltaK0;
    end
end
