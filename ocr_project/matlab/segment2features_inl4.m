function features = segment2features(I)
% I: Arbitrary binary image
% All features normalized between 0 and 1

features = zeros(5, 1);

% Crop with bounding box of digit

cols_summed_pre = sum(I, 1); % size: width of img
rows_summed_pre = sum(I, 2); % size: height

cols_nnz_idx = find(cols_summed_pre);
rows_nnz_idx = find(rows_summed_pre);

I_cropped = I(rows_nnz_idx(1):rows_nnz_idx(end), ...
    cols_nnz_idx(1):cols_nnz_idx(end));

I = I_cropped;

[rows, cols] = size(I);

% Center image at center of mass
% Image coordinate axis! right: x, down: y
center_m = center_of_mass(I);
center = round([cols/2, rows/2]);
T = center - center_m;
I = imtranslate(I, T, 'OutputView', 'full');

% Calc features
i = 1;
features(i) = has_holes(I); % 1
i = i + 1;
features(i) = has_two_holes(I); % 2
i = i + 1;

features(i) = count_middle(I); % 3
i = i + 1;

props = regionprops(I, 'MinorAxisLength','Circularity', ...
    'Eccentricity', 'Orientation', 'MajorAxisLength');

features(i) = (props.MinorAxisLength-4)/13; % 4
i = i + 1;
features(i) = (props.Circularity-0.15)/0.6; % 5
i = i + 1;

% Use pixelated image as features
output_width = 15;
output_height = 15;

% downsizes by averaging (default)
pixelated_img = imresize(I, [output_height, output_width]);

image_feature = reshape(pixelated_img, 1, []);
features = [features; image_feature']; % 225 + 5 = 230 feats

end

% --- Feature functions ---

function x = count_middle(im)
    % Count number of ones in 2x2 square in middle
    dims = size(im);
    sq_size = 2;
    
    idx = round(dims/2);
    
    middle_sq = im(idx(1):(idx(1)+1), idx(2):(idx(2)+1));
    
    % normalize
    x = sum(middle_sq, 'all') / (sq_size^2);

end


function x = has_holes(im)
    % Returns if a hole is detected
    im_filled = imfill(im, 'holes');
    
    diff = im_filled - im;
    
    x = sum(diff, 'all') > 0;
end

function x = has_two_holes(im)
    % Returns if two holes are detected
    im_filled = imfill(im, 'holes');
    
    diff = im_filled - im;

    im_labeled = bwlabel(diff, 4);
    
    has_one_hole = sum(im_labeled == 1, 'all') > 0;
    has_second_hole = sum(im_labeled == 2, 'all') > 0;
    
    x = has_one_hole & has_second_hole;
end

