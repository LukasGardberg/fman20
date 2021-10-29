function model = class_train(x, y)

y = categorical(y);

t = templateSVM('Standardize',true);
model = fitcecoc(x', y', "Learners", t);

% model = fitcknn(x', y', 'NumNeighbors',1,'Standardize',1);

end

