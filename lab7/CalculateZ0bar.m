function [Z] = CalculateZ0bar( oldZbar, Z, time, alpha, numNeurons, rise)
%Calculates a new set (column) of Zbar values for a timestep.  Takes a
%matrix containing the old Zbar values, an array with Z0 the intial input,
%a martix containing excitation values across time, the current time,
%desired alpha and number of neurons in the network.

%USES LINEAR NMDARISE
if (rise ~= 0) %if rise is 0, Zbar_i = 1 if that neuron fired, else Zbar_i is still 0 under chip's rule
 Z = 0;
end

end
