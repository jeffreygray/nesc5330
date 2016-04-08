function [w] = UpdateWeights( Zj, ZbarValueList, weightList, mu)
%Function calculates a list of updated weights. Takes a list of neuronal
%excitations (Zj), a list of Zbar values, a list of weights to be updated,
%and mu, the synaptic modification rate constant
   w = weightList + mu * Zj * (ZbarValueList - weightList);
end
