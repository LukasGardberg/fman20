datadir = '../datasets/short1'; % change or check so that you are in the right directory
% datadir = '../datasets/home3';

a = dir(datadir);

file = 'im9';

fnamebild = [datadir filesep file '.jpg'];
fnamefacit = [datadir filesep file '.txt'];

bild = imread(fnamebild);
fid = fopen(fnamefacit);
facit = fgetl(fid);
fclose(fid);

imagesc(bild)

S = im2segment(bild);
B = S{2};
% imagesc(B)

x = segment2features(B);

%%
subplot(211)
imagesc(double(bild))
size(bild)

bild2 = imresize(bild, [15, 15]);
subplot(212)
imagesc(bild2)
size(bild2)

%%
subplot(211)
imagesc(double(bild))
size(bild)
bild_dl = dlarray(double(bild), 'SS');

output_width = 15;
output_height = 15;

% determine filter sizes to conv with
f_width = size(bild, 2)/output_width ;
f_height = size(bild, 1)/output_height;

pool_size = round([f_height, f_width]);

newbild_dl = avgpool(bild_dl, pool_size);
newbild_dl = extractdata(newbild_dl);
size(newbild_dl)
subplot(212)
imagesc(newbild_dl)