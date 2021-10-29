c1 = [0.4003, 0.3988, 0.3998, 0.3997, 0.4010, 0.3995, 0.3991];
c2 = [0.2554, 0.3139, 0.2627, 0.3802, 0.3287, 0.3160, 0.2924];
c3 = [0.5632, 0.7687, 0.0524, 0.7586, 0.4243, 0.5005, 0.6769];
c_all = [c1, c2, c3];
c_labels = [ones(1, length(c1)), 2*ones(1, length(c2)), 3*ones(1, length(c3))];

c1_train = c1(1:4);
c2_train = c2(1:4);
c3_train = c3(1:4);

c_train = [c1_train, c2_train, c3_train];

c1_test = c1(5:end);
c2_test = c2(5:end);
c3_test = c3(5:end);

%% Plot all

hold on
plot(c1, 0.*c1,'ob', 'LineWidth', 1.5)
plot(c2, 0.*c2,'rx', 'LineWidth', 1.5)
plot(c3, 0.*c3,'ks', 'LineWidth', 1.5)

%% plot training examples

hold on
plot(c1_test, 0.*c1_test, 'ob')
plot(c2_test, 0.*c2_test, 'rx')
plot(c3_test, 0.*c3_test, 'ks')

%% Train k nearest classifier and run on test set

train_len = length(c1_train);

train_data = [c1_train, c2_train, c3_train];
train_labels = [ones(1, train_len), 2*ones(1, train_len), ... 
    3*ones(1,train_len)];

test_len = length(c1_test);

test_data = [c1_test, c2_test, c3_test];
test_labels = [ones(1, test_len), 2*ones(1,test_len), 3*ones(1,test_len)];

% k-nn model
Md1 = fitcknn(train_data', train_labels', ... 
    'NumNeighbors',1,'Standardize',1);
result = predict(Md1, test_data');

nbr_wrong = sum(test_labels - result' ~= 0);
nbr_samples = length(test_data);
sprintf('Classified %.0f out of %.0f samples right', ... 
    nbr_samples - nbr_wrong, nbr_samples)

%%
x_1 = c1_test(1);

dists = abs(x_1 - c_train);
c_train(1)

%% Gaussian distributions

m = [0.4, 0.3, 0.5];
sigma = [0.01, 0.05, 0.2];

classes = [1, 2, 3];
py = [1/3, 1/3, 1/3]; % All classes equally likely

% Measurement probs
px_y = @(s, i) normpdf(s, m(i), sigma(i));

% Joint probability
p_xy = @(x,i) px_y(x,i)*py(i);

% Calc post probs for all x
post_probs = zeros(length(classes), length(c_all));

for class = 1:length(classes)
    for sample = 1:length(c_all)
        x_temp = c_all(sample);
        
        post_probs(class, sample) = ... 
            p_xy(x_temp, class) / px(x_temp, m, sigma);

    end
end

[M, args] = max(post_probs);

nbr_correct = sum(c_labels - args == 0);

sprintf('Classified %.0f out of %.0f right (MAP)', ... 
    nbr_correct, length(args))


%% plot densities
x = linspace(0, 1, 1000);
colors = ['b', 'r', 'k'];
hold on
for i = 1:3
    
plot(x, px_y(x, i), colors(i), 'LineWidth', 1.5)
    
end
ylim([-5, 20])

legend('Class 1', 'Class 2', 'Class 3', ... 
    'Density f. 1', 'Density f. 2', 'Density f. 3')

%% For example calcs

mes_probs = [px_y(0.4003, 1), px_y(0.4003, 2), px_y(0.4003, 3)];
joint_probs = 1/3 * mes_probs;

norm_c = px(0.4003, m(1),sigma(1)) + ... 
    px(0.4003, m(2), sigma(2)) + px(0.4003, m(3), sigma(3));

p = joint_probs / norm_c;
sum(p)

%%


%%

% Total prob
% classes = [1, 2, 3]
function p = px(x, m, sigma)
    
    p = 0;
    % Sum joint prob for all classes
    for i = 1:length(m)
        p = p + normpdf(x, m(i), sigma(i))*(1/3);
    end

end

