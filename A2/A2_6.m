c1 = [0, 0, 1;
      0, 1, 0;
      0, 0, 1;
      0, 1, 0;
      0, 0, 1];
  
c2 = [1, 0, 1;
      0, 1, 0;
      0, 1, 0;
      0, 1, 0;
      1, 0, 1];

c3 = [1, 0, 1;
      0, 1, 0;
      1, 0, 1;
      0, 1, 0;
      1, 0, 1];
  
im = [1, 1, 1;
      0, 1, 1;
      1, 0, 1;
      1, 1, 0;
      0, 0, 1];
  
c = {c1, c2, c3};

% Priors
p_y = [0.25, 0.4, 0.35];

% Chance of black pixel error: 25%
% Chance of white pixel error: 35%
error_rates = [0.25, 0.35];

% Joint probs
p_xy = @(im, i, ep) px_y(im, c{i}, ep)*p_y(i);

% Total prob
px = 0;
for j = 1:length(c)
   px = px + p_xy(im, j, error_rates);
end

post_probs = zeros(length(c), 1);

for class = 1:length(c)
    post_probs(class) = p_xy(im, class, error_rates) / px;
end

sprintf('Class 1: %.2f%%, 2: %.2f%%, 3: %.2f%%', 100*post_probs)

%%

d = im - c3;
sum(d ~= 0, 'all')

%%
function p = px_y(x, class_img, e)
% x: observed image
% class_img: true image (to compare to)
% e: pixel error rates [e1, e2] for white & black pixels

p = 1;

% Flatten
x = reshape(x.', 1, []);
class_img = reshape(class_img.', 1, []);

% Calc prob. of each pixel
for i = 1:length(x)
    pixel_orig = class_img(i);
    pixel_obs = x(i);
    
    % Observed white, original black
    if (pixel_obs == 1) && (pixel_orig == 0)
        p = p * e(1);
    % Obs white, orig white
    elseif (pixel_obs == 1) && (pixel_orig == 1)
        p = p * (1-e(1));
    % Obs black, orig black
    elseif (pixel_obs == 0) && (pixel_orig == 0)
        p = p * (1-e(2));
    % Obs black, orig white
    elseif (pixel_obs == 0) && (pixel_orig == 1)
        p = p * e(2);
    end
    
    % Double check we actually changed p
    assert(p ~= 1, 'p did not change');
end

end


