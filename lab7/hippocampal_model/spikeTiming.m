function W = spikeTiming(C_In, W, Z, mu, delT)

% Old Rule: deltaW ~= (Zbar - Wij) (Zj) 
% New Rule: deltaW ~= f(t_pre, t_post)

% why not use a dot product!?
% have a rule in a vector, dot product it with Z, pad each side 

[a,b] = size(Z);
%add 7 to each side of Z
newZ = [zeros(a,7),Z,zeros(a,7)];

[n,t] = find(Z); %n is the neuron number, t is the time it fires.
num   = length(n); %num is the total number of spikes

rule = [-0.5, 0,  0.5,1 ,1.5, 2,  4, -0.2, -2, -1]';
offset = length(rule)-1;
for j = 1:num %cycles through all spikes where each n(j) = post neuron
 post  = n(j);
 t2  = t(j);

 %who inputs post?
 pre       = C_In(post,:)+1; %+1 for MatLab
 %now figure out when pre fires NEAR t2
 spikes    = newZ(pre,t2:(t2+offset) ); %200 by 10 matrix
 %use the rule to calculate how W should change
 delW      = spikes * rule .* mu ./ sum(spikes,2);
 %if pre never fires, delW(neverfired) = -mu
 delW(find(isnan(delW))) = -mu; %

 W(post,:) += delW';

end %for j

W = (W > 0) .* W; %get rid of negatives.
%Should we put a ceiling at 1?

end %function

% Possible code to be translated to C (It uses for loops, not vector math
%   if(any(spikes))
%     %There is at least one firing of the pre neuron.
%     [a,times] = find(spikes);
%     for k = 1:length(times) %This adds in EVERYTIME pre fires, we probably just want the one before post that is closest, unless it is -10ms
%      %now check to see if this firing is within the right window
%      timeDiff = (t2 - times(k) ) * delT;
%      if( (timeDiff > -40) && (timeDiff < 120) )
%        if(k == 1) 
%         delW = spikeRule(timeDiff) * mu; 
%        else
%	 delW += spikeRule(timeDiff) * mu; 
%        end
%      end % if
%     end %for k
%   else
%    delW = -mu;
%   end % in any



