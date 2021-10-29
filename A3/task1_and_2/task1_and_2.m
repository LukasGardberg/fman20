% SCRIPT FOR BOTH TASK 2 AND 3.
%
% Task 2: Create your own classifier and try it out by classifying images
% as faces or non-faces
%
% Task 3: Try some built-in machine learning methods for classifying these
% same images of faces / non-faces

% Clear up
clc;
close all;
clearvars;

% Begin by loading the data
load FaceNonFace
nbr_examples = length(Y);

% This outer loop will run 100 times, so that you get a mean error for your
% classifier (the error will become different each time due to the
% randomness of cvpartition, which you may verify if you wish).
nbr_trials = 100;
err_rates_test = zeros(nbr_trials, 4);
err_rates_train = zeros(nbr_trials, 4);
for i = 1 : nbr_trials
    
    % First split data into training / testing (80% train, 20% test)
    part = cvpartition(nbr_examples, 'HoldOut', 0.20);
    
    % Extract training and test data given the partition above
    X_train = X(:, part.training);
    X_test = X(:, part.test);
    Y_train = Y(:, part.training);
    Y_test = Y(:, part.test);
    
    nbr_train_examples = length(Y_train);
    nbr_test_examples = length(Y_test);
    
    % Now we can train our model!
    % YOU SHOULD IMPLEMENT THE FUNCTION class_train!
    classification_data = class_train(X_train, Y_train);
        
    % Next, let's use our trained model to classify the examples in the 
    % test data
    predictions_test = zeros(1, nbr_test_examples);
    for j = 1 : nbr_test_examples
        % YOU SHOULD IMPLEMENT THE FUNCTION classify!
        predictions_test(j) = classify(X_test(:, j), classification_data);
    end
   
    % We do the same thing again but this time for the training data itself!
    predictions_train = zeros(1, nbr_train_examples);
    for j = 1 : nbr_train_examples
        % YOU SHOULD IMPLEMENT THE FUNCTION classify!
        predictions_train(j) = classify(X_train(:, j), classification_data);
    end
    
    % We can now proceed to computing the respective error rates.
    pred_test_diff = predictions_test - Y_test;
    pred_train_diff = predictions_train - Y_train;
    err_rate_test = nnz(pred_test_diff) / nbr_test_examples;
    err_rate_train = nnz(pred_train_diff) / nbr_train_examples;
    
    % Store them in the containers
    err_rates_test(i, 1) = err_rate_test;
    err_rates_train(i, 1) = err_rate_train;
    
    %--------------------- Below: Task 3 ------------------------------%
    % 
    % Uncomment the below code when working on Task 3
    % NOTE: Running the full script can take several minutes. However, by
    % setting nbr_trials = 1 (see almost at the top of this script) when
    % trying things it will go faster.
    % 
    % DO NOT FORGET TO SET nbr_trials = 100 AGAIN WHEN REPORTING YOUR FINAL
    % RESULTS
    
    % Train built-in functions (don't forget: transpose as necessary)
    tree_model = fitctree(X_train',Y_train');
    svm_model = fitcsvm(X_train',Y_train', 'KernelFunction', 'rbf');
    nn_model = fitcknn(X_train',Y_train');
    
    % Next, let's use our trained model to classify the examples in the 
    % test data. You should look up the function "predict" in Matlab!
    % (don't forget: transpose as necessary, both for X and Y)
    predictions_test_tree = tree_model.predict(X_test');
    predictions_test_svm = svm_model.predict(X_test');
    predictions_test_nn = nn_model.predict(X_test');
   
    % We can now proceed to computing the respective error rates.
    pred_test_diff_tree = predictions_test_tree - Y_test';
    pred_test_diff_svm = predictions_test_svm - Y_test';
    pred_test_diff_nn = predictions_test_nn - Y_test';
    err_rate_test_tree = nnz(pred_test_diff_tree) / nbr_test_examples;
    err_rate_test_svm = nnz(pred_test_diff_svm) / nbr_test_examples;
    err_rate_test_nn = nnz(pred_test_diff_nn) / nbr_test_examples;
    
    % Store them in the containers
    err_rates_test(i, 2) = err_rate_test_tree;
    err_rates_test(i, 3) = err_rate_test_svm;
    err_rates_test(i, 4) = err_rate_test_nn;
    
    % Let's do the same for the training data
    % FILL IN CODE SIMILAR TO THE TEST PART ABOVE!
    
    predictions_train_tree = tree_model.predict(X_train');
    predictions_train_svm = svm_model.predict(X_train');
    predictions_train_nn = nn_model.predict(X_train');
    
    pred_train_diff_tree = predictions_train_tree - Y_train';
    pred_train_diff_svm = predictions_train_svm - Y_train';
    pred_train_diff_nn = predictions_train_nn - Y_train';
    err_rate_train_tree = nnz(pred_train_diff_tree) / nbr_train_examples;
    err_rate_train_svm = nnz(pred_train_diff_svm) / nbr_train_examples;
    err_rate_train_nn = nnz(pred_train_diff_nn) / nbr_train_examples;
    
    % Store them in the containers
    err_rates_train(i, 2) = err_rate_train_tree;
    err_rates_train(i, 3) = err_rate_train_svm;
    err_rates_train(i, 4) = err_rate_train_nn;
end

% Finally, after all the trials are done, report mean error rates
%
% NOTE: From here you get two 4-dimensional arrays, where the first entry
% is the mean error rate for your own method, and the last three
% entries are mean error rates for the built-in methods
%
% DO NOT FORGET: COMMENT ON ALL RESULTS IN THE REPORT
%
%
mean_err_rate_test = mean(err_rates_test);
mean_err_rate_train = mean(err_rates_train);

sprintf('Mean train error rate: %.3f, %.3f, %.3f, %.3f', mean_err_rate_train)
sprintf('Mean test error rate: %.3f, %.3f, %.3f, %.3f', mean_err_rate_test)



%% ------------------ FOR TASK 2 BELOW! ---------------------------------

% For the report, in addition to reporting above error rates (and
% commenting on them!), you should also manually select two images from X,
% one image of a face, and one image of a non-face. Begin by reshaping each
% such column from 361x1 to 19x19, so that you can show them using matlab's
% function "imagesc". (See "reshape" in Matlab for how to reshape a vector to a
% matrix). Provide both these images in your report INCLUDING WHAT YOUR
% MODEL PREDICTS THE RESPECTIVE IMAGES TO BE. Hopefully your model will say
% that the face is a face, and that the non-face is a non-face, but it's
% not certain of course. Make sure that the two images are extracted from
% X_test, and not X_train. Write code for this below! 

idx_1 = 7;
idx_2 = 2;

figure(1)

face_img = reshape(X_test(:, idx_1), 19, 19);
subplot(121)
imagesc(face_img)
colormap(gray)
label1 = num2str(Y_test(idx_1));

c = num2str(predictions_test(idx_1));
title(['Face (class: ' label1 '), Pred class: ' c]); 

subplot(122)
nonface_img = reshape(X_test(:, idx_2), 19, 19);
imagesc(nonface_img)
colormap(gray)
label2 = num2str(Y_test(idx_2));

c2 = num2str(predictions_test(idx_2));
title(['Nonface (class: ' label2 '), Pred class: ' c2]); 


