function out = spikeRule(timeDiff)

%timeDiff is in ms

out = -1;

if(timeDiff > -40)
 if(timeDiff < -20)
  out = (timeDiff + 40) * (-1/20) - 1;
 elseif(timeDiff < -5)
  out = -2;
 elseif(timeDiff < 15)
  out = -2 + (timeDiff+5) * 1/4;
 elseif(timeDiff < 80)
  out = 2 - (timeDiff-15)/32.5 ;
 elseif(timeDiff < 160)
  out = -(timeDiff-80)/80;
 end
end


end
