function [zbar] = CalculateZbar( Z, prevZbar, cur_time, alpha, ni, rise, timeSinceFired, firstAct, riseUntil, riseShape)
%Calculates a new set (column) of Zbar values for a timestep.  Takes a
%matrix Z, current simulation time, alpha, num_neurons, rise, time since each neuron fired,
%the time at which a a neuron first fired if the neuron is activated on a rise,
%and the shape of the rise that has [rise+1] values.

  sze = size(Z);
if(rise == 0)
  for n = 1:ni

    if (timeSinceFired(n) == 0) zbar(n) = 1; %justfired
    elseif ( timeSinceFired(n) == (sze(2)+1) ) zbar(n) = 0; %neverfired
    else zbar(n) = alpha ^ timeSinceFired(n); 
    end%if %decay
    
  end%for ni   

else %rise is >0

  for n = 1:ni

    if (timeSinceFired(n) >= (sze(2)+1) ) zbar(n) = 0; %neverfired
    elseif (timeSinceFired(n) >= rise) zbar(n) = alpha ^ (timeSinceFired(n) - rise); %decay
    else% zbar is rising, must check lots of things
	if( cur_time - firstAct(n) < rise )%still rising from earlier activation
	  zbar(n) = riseShape( cur_time - firstAct(n) + 2 ) + floor(1000*prevZbar(n))/1000;
	elseif (riseUntil(n) > cur_time) %zbar is saturated
	  zbar(n) = 1;
	else
	  zbar(n) = riseShape(timeSinceFired(n)+1) + floor(1000*prevZbar(n))/1000;
	end%if

    end%if

  end%for ni

end

zbar = (zbar .* (zbar <= 1)) + (zbar > 1); %sets all values above 1 to 1.



%%%OLD CODE
%
%      if (timeSinceFired(n) > rise)
%       zbar(n) = oldZbar(n,time-1)*alpha;
%      else
%       zbar(n) = zbar(n) + (1 / (rise));
%      end
%      if (zbar(n) > 1) 
%        zbar(n) = 1;
%      end
%      if (zbar(n) < 0)
%        zbar(n) = 0;
%      end
%    end
%
% elseif(rise == 0)
%   zbar = zbar(:) .* alpha;
%   fired = [];
%   for n = 1:ni
%	if( timeSinceFired(n) == 0)
%	 fired = [fired,n]; 
%     end
%   end
%   zbar(fired) = 1;
% end
%else %shape is defined
%
%end

