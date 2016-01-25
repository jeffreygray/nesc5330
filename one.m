m=menu(’Pick a plot’,’Sine plot’,’Cosine plot’);
if m==1,
x=(-pi):pi/40:pi;
y=sin(x);
title(’Sine’)
else
x=(-pi):pi/40:pi;
y=cos(x);
title(’Cosine’)
end
plot(x,y)