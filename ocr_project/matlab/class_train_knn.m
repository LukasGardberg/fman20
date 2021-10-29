function classification_data = class_train(X, Y)
% X: training data, (nbr_samples, dims)
% Y: training labels, (nbrs_samples, 1)

% If samples arent in row order, transpose
if(size(X,1) ~= size(Y, 1))
    X = X';
    Y = Y';
end

k = 1;

classification_data = {X, Y, k}; % REMOVE AND REPLACE WITH YOUR CODE
end

