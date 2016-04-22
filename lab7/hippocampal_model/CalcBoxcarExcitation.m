function y = CalcBoxcarExcitation( weightList, connectionList, excitationMatrix, time)

y = sum( weightList .* excitationMatrix(connectionList, time-1)'); 
end
