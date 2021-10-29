imdata = imread("arcimboldo_low.jpg");

figure(1)
imshow(imdata) % Red tint
%%
imhsv = rgb2hsv(imdata);

% Saturation and value to add
c = [0.45, 0.01];

for i = 2:3
    % Matrix to add to im
    a = ones(size(imhsv(:,:,1))) * c(i - 1);
    
    % Add to specific channel
    im_temp = imhsv(:, :, i) + a;
    
    % Clip values above 1
    clipped = im_temp > 1;
    im_temp(clipped) = 1;
    
    imhsv(:, :, i) = im_temp;

end
imagesc(hsv2rgb(imhsv))

