load('heart_data.mat')

bg_mean = mean(background_values);
bg_std = std(background_values);

ch_mean = mean(chamber_values);
ch_std = std(chamber_values);

hold on

histogram(background_values, 100);
histogram(chamber_values, 100);

% plot(background_values, background_values*0, 'r*')
% plot(chamber_values, chamber_values*0., 'bo')

x = linspace(0, 0.7);

plot(x, 50 * normpdf(x, bg_mean, bg_std), 'Color', '#0072BD')
plot(x, 50 * normpdf(x, ch_mean, ch_std), 'Color', '#D95319')

legend('Background', 'Chamber', 'Background Distr.', 'Chamber Distr.');

%% Solve min cut
nu = 5.8;

theta = segment_image(im, bg_mean, ch_mean, bg_std, ch_std, nu);

subplot(211)
imagesc(im)

subplot(212)
imagesc(theta)

%%

function Theta = segment_image(im, bg_mean, ch_mean, bg_std, ch_std, nu)
    [h, w] = size(im); % M, N
    
    N = h * w;
    
    % Generate connectivity matrix
    neighbors = edges4connected(w, h);
    i = neighbors(:, 1);
    j = neighbors(:, 2);
    
    A = sparse(i, j, 1, N, N);
    A = A * nu;
    
    neglog = @(x, m, s) 0.5 * log(2 * pi * s^2) + (x - m).^2 / (2*s^2);

    % Not using -log likelihood here,
    %T = [(im(:) - ch_mean).^2 (im(:) - bg_mean).^2];
    ch_neglog = neglog(im(:), ch_mean, ch_std);
    bg_neglog = neglog(im(:), bg_mean, bg_std);
    
    % Cost T(i,j) of assigning pixel i to class j
    T = [ch_neglog bg_neglog];
    T = sparse(T);
    
    % Solve min cut problem
    tic
    
    [E, Theta] = maxflow(A, T);
    Theta = reshape(Theta, h, w);
    Theta = double(Theta);
    
    toc

end

