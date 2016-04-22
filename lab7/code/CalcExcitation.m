function [y] = CalcExcitation( weightList, connectionList, excitationMatrix, time)
%Function to calculate a neuron's excitation. Takes a list of weights
%corresponding to the inputting neurons' weights, a matrix of neuronal
%firings across time, and a list of connections used to selected the input
%neurons from the excitation matrix
    y = sum( weightList .* excitationMatrix(connectionList, time-1)');
end
