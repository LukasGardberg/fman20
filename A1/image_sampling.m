% plot a 5x5 image matrix of f(x,y)= x(1-y) with 32 gray levels

x = linspace(0, 1, 5);

[X, Y] = meshgrid(x);
Y = flipud(Y);

f = X.*(1-Y);

f_quantified = round(f.*31);

h = heatmap(f_quantified);
h.YDisplayLabels = string(linspace(5,1,5));
colormap(gray)
colorbar off