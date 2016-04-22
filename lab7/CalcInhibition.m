function [I] = CalcInhibition( inputList, fbWeightList, excitationMatrix, ni, time, K0, Kfb, Kff)

I = K0 + Kfb * round(sum( fbWeightList .* excitationMatrix(1:ni, time-1)')*1000000)/1000000 ... 
          + Kff * sum(inputList) ; %rounding to match NJ
end
