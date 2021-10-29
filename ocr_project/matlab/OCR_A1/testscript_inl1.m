datadir = '../datasets/short1';
a = dir(datadir);

% Select a filename
file = 'im1';

% Generate filename with path and extension
fnamebild = [datadir filesep file '.jpg'];
fnamefacit = [datadir filesep file '.txt'];

% Read an image and convert to double
bild_pre = imread(fnamebild);
bild = double(bild_pre);

subplot(3,1,1)
imagesc(bild)
colormap(gray)
%%
subplot(3,1,2)
imagesc(histeq(bild))

subplot(3,1,3)
shrp_kernel = [0, -1, 0;
               -1, 5, -1;
               0, -1, 0];

conv_img = conv2(bild, [1/4, 1/4; 1/4, 1/4], 'same');
conv_img = conv2(conv_img, shrp_kernel, 'same');
imagesc(conv_img);

%%
subplot(2,1,1)
imhist(histeq(bild/255))

fid = fopen(fnamefacit);
facit = fgetl(fid);
fclose(fid);
imshow(facit);

%%

imagesc(imsegkmeans(bild_pre, 2))
%%

a = im2segment(bild);
nrofsegments = length(a);
subplot(nrofsegments+1, 1, 1)
imagesc(bild)

for i = 1:length(a)
    subplot(nrofsegments+1, 1, i+1)
    imagesc(a{i});
end
colormap(gray)
%% Plot original and segmented
a = im2segment(bild);
nrofsegments = length(a);

h = size(bild, 1);
w = size(bild, 2);

subplot(2, 1, 1)
imagesc(bild)
title('Original')
bild2 = zeros(h, w);

for i = 1:length(a)
    start_index = 1 + (i - 1)*h;
    end_index = h * i;
    
    bild2(:, start_index:end_index) = a{i}(:, start_index:end_index);
end

subplot(2,1,2)
imagesc(bild2)

colormap(gray)

title('Segmented')
%% Morph opening

se = [1, 0; 1, 0];
bild_after = bwareaopen(bild2, 2);

figure
subplot(411)
imshow(bild, []);

subplot(412)
imshow(bild2, []);

subplot(413)
imshow(bild_after,[]);

%%

inl1_test_and_benchmark

% 0.8651 - 36


