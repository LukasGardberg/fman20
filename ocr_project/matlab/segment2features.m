function features = segment2features(I)
% I: Arbitrary binary image
% All features normalized between 0 and 1

features = zeros(5, 1);
I_orig = I;

% Idea: remove normalization in NN?

% Crop with bounding box of digit!

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
% features(i) = count_pixels(I);
% i = i + 1;

% features(i) = count_pixels_in_dim(I, 1);
% i = i + 1;
% features(i) = count_pixels_in_dim(I, 2);
% i = i + 1;

% features(i) = edge_corr(I, 'horizontal');
% i = i + 1;
% features(i) = edge_corr(I, 'vertical'); % 5
% i = i + 1;
% features(i) = edge_corr(I, 'diagonal'); % 6
% i = i + 1;

features(i) = has_holes(I); % 1
i = i + 1;
features(i) = has_two_holes(I); % 2
i = i + 1;

% features(i) = measure_symmetry(I);
% i = i + 1;

features(i) = count_middle(I); % 3
i = i + 1;

% features(i) = count_pixels_in_half(I, 'left');
% i = i + 1;
% features(i) = count_pixels_in_half(I, 'right');
% i = i + 1;
% features(i) = count_pixels_in_half(I, 'up');
% i = i + 1;
% features(i) = count_pixels_in_half(I, 'down');
% i = i + 1;

props = regionprops(I, 'MinorAxisLength','Circularity', ...
    'Eccentricity', 'Orientation', 'MajorAxisLength');

features(i) = (props.MinorAxisLength-4)/13; % 4
i = i + 1;
features(i) = (props.Circularity-0.15)/0.6; % 5
i = i + 1;
% features(i) = (props.Eccentricity-0.6)/0.4;
% i = i + 1;
% features(i) = props.Orientation/180 + 0.5; % -90 to 90 (18)
% i = i + 1;
% features(i) = props.MajorAxisLength / 32; % 19
% i = i + 1;

% std2 = std(I, 0, 'all');
% features(i) = moment(I, 2, 'all'); % 20
% i = i + 1;
% features(i) = (moment(I, 3, 'all')/(std2^3))/2 + 0.5;
% i = i + 1;
% features(i) = moment(I, 4, 'all')/(2 * std2^4); % 22
% i = i + 1;

% Use pixelated image as features?
output_width = 15;
output_height = 15;

% downsizes by averaging (default)
pixelated_img = imresize(I, [output_height, output_width]);

image_feature = reshape(pixelated_img, 1, []);
features = [features; image_feature']; % 225 + 5 = 230 feats

subplot(211)
imagesc(I)

subplot(212)
imagesc(pixelated_img)

% PROBLEM: får inte rätt antal features ut, bara nollor??

end

% --- Feature functions ---

function x = count_pixels(im)
    % Returns ratio of 1's in image
    
    nbr = sum(im, 'all');
    nbr_pixels = size(im, 1) * size(im, 2);
    
    x = nbr/nbr_pixels;
end

function x = count_middle(im)
    % Count number of ones in 2x2 square in middle
    dims = size(im);
    sq_size = 2;
    
    idx = round(dims/2);
    
    middle_sq = im(idx(1):(idx(1)+1), idx(2):(idx(2)+1));
    
    % normalize
    x = sum(middle_sq, 'all') / (sq_size^2);

end

function x = count_pixels_in_dim(im, dim)
    % Counts number of rows / cols that has pixels in them
    % row: dim=1, col: dim=2
    
    dims_summed = sum(im, 3 - dim);
    x = sum(dims_summed > 0, 'all') / size(im, dim);

end

function x = count_pixels_in_half(im, half)
    % half = left, right, up, down
    mids = round((size(im)/2));
    middle_row = mids(1);
    middle_col = mids(2);
    
    if strcmp(half, 'left') % Left side
        cut_im = im(:, 1:middle_col);
    elseif strcmp(half, 'right') % Right side
        cut_im = im(:, (middle_col+1):end);
    elseif strcmp(half, 'up') % Upper side
        cut_im = im(1:middle_row, :);
    elseif strcmp(half, 'down') % Lower side
        cut_im = im((middle_row+1):end, :);
    end
    
    cut_size = size(cut_im, 1) * size(cut_im, 2);
    x = sum(cut_im, 'all')/cut_size;
end

function x = edge_corr(im, direction)
    % fraction of pixels that are hor / vert edge pixels

    if strcmp(direction, 'horizontal')
        k = [1, -1];
    elseif strcmp(direction, 'vertical')
        k = [1; -1];
    elseif strcmp(direction, 'diagonal')
        k = [0, 1, 2;
            -1, 0, 1;
            -2,-1, 0];
    end
        
    nbr_pixels = sum(im, 'all');
    
    im_conv = conv2(im, k);
    
    % ratio of left edges to nbr of pixels
    x = sum(im_conv > 0, 'all')/nbr_pixels;
    
    % idea: 1's have more x edges than y
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

function x = measure_symmetry(im)
    % Aligns im (rotates) along its axis of orientation
    % mirrors it in this axis and takes difference

    props = regionprops(im, 'Orientation');
    orientation = props.Orientation;

    middle = round(size(im, 2) / 2);
    
    if orientation < 0
        orientation = -orientation;
    end

    im_r = imrotate(im, 90-orientation, 'crop');

    pixel_sum = sum(im, 'all');
    
    diff = im_r - fliplr(im_r);

    % More elements ~= 0 -> less symmetric

    remainder = sum(diff(:, middle:end) ~= 0, "all");

    x = 1 - remainder/pixel_sum;

end


% TODO: 
%
% Column / rad med flest 1:or?
% Hål-detection?
% Antal hål

% Idea of getting symmetry axis of image:

% labeledImage = bwlabel(binaryImage);
% props = regionprops(labeledImage, 'Orientation', 'Centroid');
% orientation = props.Orientation % Angle in degrees.
% xCentroid = props.Centroid(1)
% yCentroid = props.Centroid(2)

% Use this to measure symmetry?




