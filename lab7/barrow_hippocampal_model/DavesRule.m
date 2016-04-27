function [w] = DavesRule( excitationValue, excitationSum, weightList, lambda, activity, ni)
%Function to calculate a list of updated feedback interneuron weights. Takes a list of neuronal
%excitations [Z(t-1)], the sum excitation on the current timestep, a list of weights to be updated,
%lambda the synaptic modification rate constant, the desired activity, and
%the number of neurons in the simulation.
    w = weightList + lambda * excitationValue(1:ni) * (excitationSum/ni - activity);
end
