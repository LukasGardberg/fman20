% Task 1: Fit least squares and total least squares lines to data points.

% Clear up
clc;
close all;
clearvars;

% Begin by loading data points from linjepunkter.mat
load linjepunkter

N = length(x); % number of data points

% Plot data
plot(x, y, '*'); hold on;
xlabel('x') 
ylabel('y')
title('Line fit using least squares and total least squares') % OBS - CHANGE TITLE!
x_fine = [min(x)-0.05,max(x)+0.05]; % used when plotting the fitted lines

% Fit a line to these data points with least squares
% Here you should write code to obtain the p_ls coefficients (assuming the
% line has the form y = p_ls(1) * x + p_ls(2)).
% p_ls = [rand(), 6]; % REMOVE AND REPLACE WITH LEAST SQUARES
p_ls = least_squares(x, y);
plot(x_fine, p_ls(1) * x_fine + p_ls(2))

% Fit a line to these data points with total least squares.
% Note that the total least squares line has the form 
% ax + by + c = 0, but the plot command requires it to be of the form
% y = kx + m, so make sure to convert appropriately.
% p_tls = [rand(), 6]; % REMOVE AND REPLACE WITH TOTAL LEAST SQUARES
p_tls = total_least_squares(x, y);
plot(x_fine, p_tls(1) * x_fine + p_tls(2), 'k--')

% Legend --> show which line corresponds to what (if you need to
% re-position the legend, you can modify rect below)
h=legend('data points', 'least-squares','total-least-squares');
rect = [0.20, 0.65, 0.25, 0.25];
set(h, 'Position', rect)

% After having plotted both lines, it's time to compute errors for the
% respective lines. Specifically, for each line (the least squares and the
% total least squares line), compute the least square error and the total
% least square error. Note that the error is the sum of the individual
% squared errors for each data point! In total you should get 4 errors. Report these
% in your report, and comment on the results. OBS: Recall the distance formula
% between a point and a line from linear algebra, useful when computing orthogonal
% errors!

% WRITE CODE BELOW TO COMPUTE THE 4 ERRORS

%%

% p_ls: coeffs for least sq line
% p_tls: coeffs for tot least sq line

% 1: least sq fit
% 2: total least sq fit

errors_ls = zeros(2,1); % 1: least sq, least sq error. 2: tls, least sq err
errors_tls = zeros(2,1); % 1: least sq, tls error. 2: tls, tls error

A = ones(N,2);
A(:,1) = x';

errors_ls(1) = sum((A * p_ls' - y).^2, 'all');
errors_ls(2) = sum((A * p_tls' - y).^2, 'all');

% ax + by + c = 0, a=-p_ls(1), b=1, c=-p_ls(2)
errors_tls(1) = orth_error(-p_ls(1), 1, -p_ls(2), x, y);
errors_tls(2) = orth_error(-p_tls(1), 1, -p_tls(2), x, y);



%%
function err = orth_error(a,b,c,x,y)
    err = 0;
    for i = 1:length(x)
        err_temp = abs(a*x(i) + b*y(i) + c) / sqrt(a^2+b^2);
        err = err + err_temp^2;
    end

end
