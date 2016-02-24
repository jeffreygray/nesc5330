function [activity]=capF(raw)  % Does not allow cell activity to exceed 1 or be negative
if raw > 1        
    activity=1;
elseif raw < .05  % the activity is considered zero when it is below 0.05
    activity=0;
else
    activity = raw;
end
    