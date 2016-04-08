function [w] = UpdateWeights2( excitationValue, ZbarValueList, weightList, mu)
%Function calculates a list of updated weights. Takes a list of neuronal
%excitations (Z), a list of Zbar values, a list of weights to be updated,
%and mu, the synaptic modification rate constant

resolution 	= 10^-3;
inv 		= 1/resolution;

floored 	= floor(mu * (ZbarValueList - weightList)*inv)/inv;
nonfloored 	= mu * (ZbarValueList - weightList);
diff 		= nonfloored-floored;
w 		= floored + weightList;
[m,n] 		= size(w);

randpercent 	= (diff/resolution);
randNum 	= rand(m,n);
dW		= (randpercent > randNum) * resolution;

w = w + dW;

end
