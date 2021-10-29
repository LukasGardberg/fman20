function features = segment2features(I)
% Send whole image as feature

% We either have sizes of 28 x 140 or 70 x 350

[height, width] = size(I);
out_img = zeros(70, 350);

% Add I onto empty image, handles images smaller than 70x350

out_img(1:height, 1:width) = I;

features = reshape(out_img,1,[]);

end

