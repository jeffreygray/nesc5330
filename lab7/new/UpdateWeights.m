function [w] = UpdateWeights( Zj, ZbarValueList, weightList, mu, spike)
%Function calculates a list of updated weights. Takes a list of neuronal
%excitations (Zj), a list of Zbar values, a list of weights to be updated,
%and mu, the synaptic modification rate constant
   dw = mu * Zj * (ZbarValueList - weightList);
   if(~spike)
       w = weightList + dw;
   else
       w = weightList - dw;
   end
end
