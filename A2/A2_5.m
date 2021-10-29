im = [0, 1, 1, 1;
      1, 0, 1, 1;
      1, 1, 0, 1;
      1, 0, 1, 1];

c = {ones(4), ones(4), ones(4), ones(4)};

for i = 1:length(c)
c{i}(:, i) = zeros(4, 1);
end

py = [0.3, 0.2, 0.2, 0.3];

epsilon = 0.2;

% Joint probs
p_xy = @(im, i, ep) px_y(im, c{i}, ep)*py(i);

% Total prob
px = 0;
for j = 1:length(c)
   px = px + p_xy(im, j, epsilon); 
end

post_probs = zeros(length(c), 1);

for class = 1:length(c)
    post_probs(class) = p_xy(im, class, epsilon) / px;
end

sprintf('Class 1: %.2f%%, 2: %.2f%%, 3: %.2f%%, 4: %.2f%%', 100*post_probs)


%%

% Measurement probability function
function p = px_y(x, class_img, e)
% x: observed image
% class_img: true image (to compare to)
% e: pixel error rate

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