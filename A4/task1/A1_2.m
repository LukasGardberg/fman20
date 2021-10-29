imdata = imread('michelangelo_shift.jpg');

figure(1)
imshow(imdata) % Red tint

%%

% Try white world assumption, scale all color channels so that maximum is
% white.

im_lin = rgb2lin(imdata); % Convert to 0-1

top_percentile = 60;
illuminant = illumwhite(imdata, top_percentile); % Red highest value

im_corr_lin = chromadapt(im_lin, illuminant, 'ColorSpace', 'linear-rgb');

im_corr = lin2rgb(im_corr_lin);

figure(2)
imshow(im_corr)
illumwhite(im_corr, 1)

% hm doesnt really get much better

%% Gray world assumption

% Scale image so that avg color is gray
% Set average of each color channel to 128

rgb_mean = mean(imdata, [1, 2])

im_scaled = imdata;

for i = 1:3
    im_scaled(:, :, i) = im_scaled(:, :, i) * (128 / rgb_mean(i)) + 30;
end

figure(2)
imshow(im_scaled)
max(im_scaled, [], [1, 2])

figure(3)
im_orig = imread("michelangelo_orig.jpg");
imagesc(im_orig)

%% with matlab functions
hold on

imdata_lin = rgb2lin(imdata);

bot = 90;
top = 0;

p = 1;

ill_gw1 = illumgray(imdata_lin, [bot, top], 'Norm', p)

im_gw1 = chromadapt(imdata, ill_gw1, 'ColorSpace', 'linear-rgb');

for i = 1:3
    im_gw1(:, :, i) = im_gw1(:, :, i) - 30;
end


im2 = lin2rgb(im_gw1);
imshow(im2)


im_orig = imread("michelangelo_orig.jpg");
% imagesc(im_orig)

