file = 'Lorde_-_Melodrama';
datadir = '../A2';

fnamebild = [datadir filesep file '.jpg'];
im = imread(fnamebild);

bild_g = double(rgb2gray(im));
figure(1); colormap(gray);
imagesc(bild_g)

%%

f_1 = [-1, 1];

bild_f1 = conv2(bild_g, f_1);
bild_f11 = conv2(bild_g, [1, -1]);

subplot(121)
imagesc(bild_f1)

subplot(122)
imagesc(bild_f11)
colormap(gray);
%%

bild_f2 = conv2(bild_g, [-1; 1]);

imagesc(bild_f2)
colormap(gray);

%%
f_4 = [0, -1, 0; -1, 4, -1; 0, -1, 0];

bild_f4 = conv2(bild_g, f_4, 'same');
imagesc(bild_f4)
colormap(gray)

%%

f_5 = [1, -1, -1, -1, -1;
       1,  1, -1, -1, -1;
       1,  1,  1, -1, -1;
       1,  1,  1,  1, -1;
       1,  1,  1,  1,  1];
   
bild_f5 = conv2(bild_g, f_5, 'same');
imagesc(bild_f5)
colormap(gray)

%%

bild_test = conv2(bild_g, -[0, 1; -1, 0], 'same');
imagesc(bild_test)
colormap(gray)