load('FaceNonFace.mat')

first_image = X(:,1);
im_len = length(first_image);
d = round(sqrt(im_len));
im = reshape(first_image, d, d);

% imagesc(im)

SVMModel = fitcsvm(X',Y','Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');

% 10 fold cross val
CVSVMModel = crossval(SVMModel);

classLoss = kfoldLoss(CVSVMModel)

%%

load ionosphere