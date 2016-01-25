m = menu('pick a plot','one','two','three');
if m == 1,
    x = (-pi):pi/40:pi;
    y = sin(x);
    title('sine')
else 
    x = (-pi):pi/40:pi;
    y = cos(x);
    title('cosine')
end
plot (x,y)