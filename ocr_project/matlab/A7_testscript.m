%% Load image

datadir = '../datasets/short1';
a = dir(datadir);

% Select a filename
file = 'im8';

% Generate filename with path and extension
fnamebild = [datadir filesep file '.jpg'];

% Read an image and convert to double
bild_pre = imread(fnamebild);
bild = double(bild_pre);

%imagesc(bild)
%colormap(gray)

%

a = im2segment(bild);
nrofsegments = length(a);

h = size(bild, 1);
w = size(bild, 2);

subplot(2, 1, 1)
imagesc(bild)
title('Original')
colormap(gray)
bild2 = zeros(h, w);

x = zeros(8, 5);

for i = 1:length(a)
    start_index = 1 + (i - 1)*h;
    end_index = h * i;
    
    bild2(:, start_index:end_index) = a{i}(:, start_index:end_index);
    x(:,i) = segment2features(a{i});
end

subplot(212)
imagesc(bild2)


%%

bild_filled = imfill(bild2, 'holes');
diff = bild_filled - bild2;

bild_lab = bwlabel(diff, 4);
subplot(313)
imagesc(bild_lab)

