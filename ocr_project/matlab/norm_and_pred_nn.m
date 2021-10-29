% normalize features and predict using network

load ocrsegments

nbr_custom_feats = 5;
nbr_feats = nbr_custom_feats + 225;

S_feats = zeros(nbr_feats, 100);
for i = 1 : numel(S)
    S_feat = segment2features(S{i});
    S_feats(:, i) = S_feat;
end

%  to 0-1
for i = 1:nbr_custom_feats
    S_feats(i, :) = normalize(S_feats(i, :));
    S_feats(i, :) = rescale(S_feats(i, :));
end


classification_data = class_train(S_feats, y);

save('classification_data.mat', 'classification_data')

%%
% run script to get all features of dataset
% This will output hitrates using both normalized and unnormalized features

inl4_test_and_benchmark

% Our calculated features and correct classes
load allX
load allY

correct = zeros(size(allY));

% Normalize test class features
for i = 1:nbr_custom_feats
    allX(i, :) = rescale(normalize(allX(i, :)));
end

% Predict
for j = 1:length(allY)
    y_temp = features2class(allX(:,j), classification_data);
    correct(j) = (y_temp == allY(j));
end

sum(correct, 'all') / length(correct)