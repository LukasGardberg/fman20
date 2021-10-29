function y = features2class(x, classification_data)
% x: new samples to classify, (nbr_samples, dims)
% class. data: cell w data defining trained model

% transpose data to classify
x = x';

X_train = classification_data{1};
Y_train = classification_data{2};
k = classification_data{3};

% Find k nearest neighbors for each sample in x

% Norm along each row
distances = vecnorm(X_train - x, 2, 2);

% smallest k distances
[smallest, idx] = mink(distances, k);

closest_classes = Y_train(idx);

y = mode(closest_classes);
end

