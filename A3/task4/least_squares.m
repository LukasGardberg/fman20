function p_ls = least_squares(x, y)
% Returns least squares fit of line to 'data'
% wrt params k, m in y = k * x + m

% size of x, y: (nbr_samples, 1)

% Assumes only errors in y-direction
% Line is not vertical (k would have to be inf)

nbr_samples = length(x);

A = ones(nbr_samples, 2);
A(:,1) = x';

p_ls = A\y;
% p_ls = inv(A'*A)*A'*y;

p_ls = p_ls';
end

