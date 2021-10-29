
f = [3, 4, 7, 4, 3, 5, 6];

%%
hold on
%plot(f)
plot(f, 'rx')
ylim([0,7])
xlabel('Pixel index')
ylabel('Pixel value')
%%
x = linspace(1, 7, 700);

vals = zeros(7, 700);

for i = 1:7
    vals(i,:) = arrayfun(@g, x-i)*f(i);
end
%%
hold on
points = sum(vals);

plot(x, points)

for i=1:7
    plot(x, vals(i,:))
end

ylim([0.01, 7])
xlabel('Pixel index')
ylabel('Pixel value')
%%
g_abs(1)
x2 = linspace(-3, 3);
g2 = arrayfun(@g_abs, x2);
plot(x2, g2)
xlabel('x')
ylabel('g(x)')

%%

x = linspace(1, 7, 700);

vals2 = zeros(7, 700);

for i = 1:7
    vals2(i,:) = arrayfun(@g_abs, x-i)*f(i);
end

points2 = sum(vals2);
plot(x, points2, 'b')

%%

function f = g_abs(x)
    if abs(x) <= 1
        f = abs(x)^3 - 2*abs(x)^2 + 1;
    elseif (1 < abs(x)) & (abs(x) <= 2)
        f = -abs(x)^3 + 5*abs(x)^2 - 8*abs(x)+4;
    elseif abs(x) >2
        f = 0;
    end
end

%%

function f = g(x)
if (-1 <= x) & (x <= 0)
    f = x+1;
elseif (0 <= x) & (x <= 1)
    f = 1-x;
else
    f = 0;
end
end
