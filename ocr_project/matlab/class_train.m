function net = class_train(x, y)
% x: training data, (nbr_features, nbr_samples)
% x: training labels, (1, nbr_samples)

% Feature selection?

feat_select = 0;

if feat_select

    [idx, scores] = fscchi2(x', y');

    idx_scores = zeros(length(idx), 2);
    for i = 1:length(idx)
        idx_scores(i, :) = [idx(i), scores(idx(i))];
    end
    
    [~, I] = sort(scores, 'descend');
    
    bar(scores(I)); 
    set(gca, 'XTickLabel', I)

end

validate = 1;

nbr_features = size(x, 1);
nbr_samples = size(x, 2);

nbr_labels = max(y);
y = categorical(y);

% Worked for inl4
max_epochs = 700;
reg_param = 0.1;
drop_rate = 0.3;

layers = [
    featureInputLayer(nbr_features, 'Normalization', 'rescale-zero-one')
    % featureInputLayer(nbr_features)
    fullyConnectedLayer(256)
    reluLayer

    dropoutLayer(drop_rate)
    
    fullyConnectedLayer(nbr_labels)
    softmaxLayer
    classificationLayer];

if validate
    % Get 10 validation data points
    val_size = round(size(x,2) * 0.1); % 10% split
    
    idx = randperm(size(x,2), val_size);
    XValidation = x(:, idx);
    x(:, idx) = [];
    YValidation = y(idx);
    y(:, idx) = [];


    x = x';
    y = y';

    % 500 - 700 epochs to avoid overfit?
    
    options = trainingOptions('sgdm', ...
        'InitialLearnRate',0.01, ...
        'MaxEpochs',max_epochs, ...
        'Shuffle','every-epoch', ...
        'Verbose',false, ...
        'Plots','training-progress', ...
        'L2Regularization', reg_param, ...
        'ValidationData', {XValidation', YValidation'}, ...
        'ValidationFrequency',30);

else 
    x = x';
    y = y';
    
    options = trainingOptions('sgdm', ...
        'InitialLearnRate',0.01, ...
        'MaxEpochs',max_epochs, ...
        'Shuffle','every-epoch', ...
        'Verbose',false, ...
        'Plots','training-progress', ...
        'L2Regularization', reg_param);

end

net = trainNetwork(x, y, layers, options);

end