function makeSequences(filterSize, stutterCS, stutterUS, trace, NumTrials, ni, Me, preCS, activity);


TrainTime = preCS + stutterCS + trace + stutterUS;
%set up possible patterns for externals
CStemp = zeros(filterSize, stutterCS); 
UStemp = zeros(filterSize, stutterUS);
for b = 1:filterSize
   CStemp(b , b:filterSize:stutterCS) = 1;
   UStemp(b , b:filterSize:stutterUS) = 1;
end%forb

%make a Train and Test sequence for each trial
for T = 1:NumTrials
	temp  = zeros(ni,TrainTime);

	%Make the preload
	for i = 1:preCS
		temp( randperm(ni)(1:(ni * activity)) ,i) = 1;
	end
	
	%copy it to test seq
	temp2 = temp;

	%randomly assign each Me to a group
	type1 = mod(randperm(Me),filterSize)+1;
	type2 = mod(randperm(Me),filterSize)+1;
	for x = 1:Me
	   temp( x,    (preCS+1):(preCS+stutterCS) )         = CStemp(type1(x),:) ;
	   temp( x+Me, (TrainTime-(stutterUS-1)):TrainTime ) = UStemp(type2(x),:);
	   temp2(x,    (preCS+1):(preCS+stutterCS) )         = CStemp(type1(x),:) ;
	end%for Me

	%write each sequence in a format that NJ can use
	filename1 = ['TrainSeq_', num2str(T), '.dat'];
	filename2 = ['TestSeq_', num2str(T), '.dat'];
	dlmwrite(filename1, temp', ' '); %note the tick marks, NJ is transposed from the matlab trace code
	dlmwrite(filename2, temp2', ' ');
end%for T
