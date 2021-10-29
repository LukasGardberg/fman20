% datadir = '../datasets/short1';
datadir = '../datasets/home1';
a = dir(datadir);

% Select a filename
file = 'im157';

% Generate filename with path and extension
fnamebild = [datadir filesep file '.jpg'];
fnamefacit = [datadir filesep file '.txt'];

% Read an image and convert to double
bild = double(imread(fnamebild));

S = im2segment(bild);

figure(1)
subplot(211)
imagesc(bild)

subplot(212)
imagesc(S{1} + S{2} + S{3} + S{4} + S{5})

%%
figure(1);
subplot(7,1,1)
imagesc(bild)

S_all = zeros(size(S{1}));
for i = 1:length(S)
    S_all = S_all + S{i};
    subplot(7,1,i+1)
    imagesc(S{i})
end

subplot(717)
imagesc(S_all)

%%

labeledImage = S{5};
[rows, cols] = size(labeledImage);

center_m = center_of_mass(labeledImage);

center = round([cols/2, rows/2]);
T = center - center_m;
I = imtranslate(labeledImage, T);

props = regionprops(labeledImage, 'Orientation', 'Circularity');
orientation = props.Orientation; % Angle in degrees.
circularity = props.Circularity;

if orientation < 0
    orientation = -orientation;
end

middle = round(size(I, 2) / 2);

subplot(411)
imagesc(I)

subplot(412)
im_r = imrotate(I, 90 - orientation, 'crop');
imagesc(im_r)

subplot(413)
imagesc(fliplr(im_r))

subplot(414)
diff = im_r - fliplr(im_r);
imagesc(diff)
% f = segment2features(I);

pixel_sum = sum(I, 'all')
rem = sum(diff(:, middle:end) ~= 0, 'all')

1 - rem / pixel_sum

colorbar
%%

% hold on
% plot(x, y, 'r-', 'LineWidth', 3);


% Draw a line through the center at the centroid
% x = 1 : cols;
% slope = atand(orientation);
% y = slope * (x - center(1)) + center(2);
% y = rescale(y, 1, rows);
% y = round(fliplr(y));
% 
% im_line = zeros(size(labeledImage));
% 
% for i = 1:length(x)
%     im_line(y(i), x(i)) = 1;
% end