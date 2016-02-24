function [activity]=errcapF(raw)
if raw>1
    activity=1;
    %activity = raw;
elseif raw<0
     activity=0;
else activity = raw;
end
    