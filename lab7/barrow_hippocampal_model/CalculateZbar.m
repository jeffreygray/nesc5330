function [zbar] = CalculateZbar( Z, prevZbar, cur_time, alpha, ni, rise, timeSinceFired)
%Calculates a new set (column) of Zbar values for a timestep.  Takes a
%matrix Z, current simulation time, alpha, num_neurons, rise, time since each neuron fired,
%the time at which a a neuron first fired if the neuron is activated on a rise,
%and the shape of the rise that has [rise+1] values.
    sze = size(Z);
    for n = 1:ni
      if (timeSinceFired(n) == rise) zbar(n) = 1; %justfired
      elseif ( timeSinceFired(n) == (sze(2)+1) ) zbar(n) = 0; %neverfired
      else zbar(n) = alpha ^ timeSinceFired(n);
      end%if %decay
    end%for ni

    zbar = (zbar .* (zbar <= 1)) + (zbar > 1); %sets all values above 1 to 1.
end
