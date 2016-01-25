x = (-pi):pi/40:pi
y = x.*sin(3*x.^2).exp(-x.^2/4);
plot(x, y)
