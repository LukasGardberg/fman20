load FaceNonFace
nbr_examples = length(Y);

nbr_trials = 1;

err_rates_test = zeros(nbr_trials,1);
err_rates_train = zeros(nbr_trials,1);

for trial = 1:nbr_trials
    % get random cross vali dataset for each trial
    part = cvpartition(nbr_examples, 'HoldOut', 0.2);
    
    X_train = X(:, part.training);
    X_test = X(:, part.test);
    Y_train = Y(:, part.training);
    Y_test = Y(:, part.test);
    
    nbr_train_examples = length(Y_train);
    nbr_test_examples = length(Y_test);
    
    net = trainSimpleCNN(X_train, Y_train);
    
    % Classify all test samples
    predictions_test = predictSimpleCNN(net, X_test);
    % & training samples
    predictions_train = predictSimpleCNN(net, X_train);
    
    % Calc err rates
    pred_test_diff = predictions_test - Y_test;
    pred_train_diff = predictions_train - Y_train;
    err_rate_test = nnz(pred_test_diff) / nbr_test_examples;
    err_rate_train = nnz(pred_train_diff) / nbr_train_examples;
    
    err_rates_test(trial, 1) = err_rate_test;
    err_rates_train(trial, 1) = err_rate_train;
    
    disp(['Epoch: ', num2str(trial), ' Test error: ' num2str(err_rate_test)]);
    
end
%
mean_err_rate_test = mean(err_rates_test);
mean_err_rate_train = mean(err_rates_train);

sprintf('Mean train error rate: %.3f', mean_err_rate_train)
sprintf('Mean test error rate: %.3f', mean_err_rate_test)


%% Look at learned filters

filters = net.Layers(2).Weights;

figure(1)

for i = 1:size(filters, 4)
    subplot(2,4,i)
    imagesc(filters(:,:,1,i));
    colormap(gray)
    
end


