function x = CalcBoxcarInhibition(inputList, fbWeightList, excitationMatrix, ni, time, K0, Kfb, Kff)

x = K0 + Kfb * sum( fbWeightList .* excitationMatrix(1:ni, time-1)');
end
