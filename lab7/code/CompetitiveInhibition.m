function [y] = CompetitiveInhibition( newExcitations, excitationList, numNeurons, numToFire)
%Function to competitively inhibit network excitation. Takes a list of
%exciation values, a list of current firings (firings from external input),
%the total number of neurons in the network, and the number of neurons
%allowed to fire competitively. Returns a list which is the firing pattern
%for the current timestep
  [values, origpos] = sort(newExcitations);
  index = numNeurons; %start at bottom
  while(sum(excitationList) < numToFire)
      excitationList(origpos(index)) = 1;
      index = index - 1;
  end
  % Display warning if tie occurs
  if(values(index) == values(index+1))
      disp('Tie was broken!');
  end
  y = excitationList;
end
