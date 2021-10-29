% Our three classes
c1 = [0, 1; 1, 0];
c2 = [1, 0; 0, 1];
c3 = [1, 1; 1, 0];

py = [1/4, 1/2, 1/4];

c = {c1, c2, c3};

im = [0, 1; 1, 1];
epsilon = 0.05;

% Measurement probs
px_y(im, c{3}, epsilon)

% Joint
p_xy = @(im, i, ep) px_y(im, c{i}, ep) * py(i);

% Total prob
px = 0;
for j = 1:length(c)
   px = px + p_xy(im, j, epsilon); 
end

post_probs = zeros(length(c), 1);

for class = 1:length(c)
    post_probs(class) = p_xy(im, class, epsilon) / px;
end

sprintf('Class 1: %.2f%%, 2: %.2f%%, 3: %.2f%%', 100*post_probs)

function p = px_y(x, class_img, e)
p = 1;

x = reshape(x.', 1, []);
class_img = reshape(class_img.', 1, []);

for i = 1:length(x)
    diff = x(i) - class_img(i);
    if diff == 0
        p = p * (1 - e);
    else
        p = p * e;
    end
end

end