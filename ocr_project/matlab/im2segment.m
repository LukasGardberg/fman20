function S = im2segment(im, threshold)
% Takes in an image 'im' containing several
% square images which are segmented through thresholding

do_plot = 0;
pause_time = 0.5;

% Make sure im is double, otherwise
% weird behaviour!
im = double(im);

% equalize histogram
im = histeq(im/256, 16); % range: [0, 1]
im_orig = im;

if do_plot, imagesc(im); pause(1), end

if nargin < 2
    threshold = 0.83;
end

% Binarization
im = im > threshold;

if do_plot, imagesc(im); pause(pause_time), end

m = size(im,1); % height
n = size(im,2); % width

im_old = im;

% remove all pixels with =< open_size neighbors w bwareaopen
open_thr = 0.0005;
open_size = round(n * m * open_thr);
im = bwareaopen(im, open_size);

if do_plot, imagesc(im); pause(pause_time), end

% Reduce noise with morph. open. Try to get good size of disk
% depending on size of image
disk_factor = 0.0001;
potential_rad = round(m * n * disk_factor);
disc_radius = max([0, potential_rad-1]);

open_el = strel('disk', disc_radius);
im = imopen(im, open_el);

if do_plot, imagesc(im); pause(pause_time), end

% Initialize cell
S = cell(1, 5);

for i = 1:5
    S{i} = zeros(size(im));
end

% Automatic segment labeling
[im_labeled, nbr_labels] = bwlabel(im, 4);

% If we still have some noise blobs that can mess with our bounding box,
% remove them here

if nbr_labels > 5
    
    im = bwareaopen(im, 6, 8);
    [im_labeled, nbr_labels] = bwlabel(im, 4);

end

% Get bounding box for threshold

cols_summed_pre = sum(im, 1); % size: width of img
rows_summed_pre = sum(im, 2); % size: height

cols_nnz_idx = find(cols_summed_pre);
rows_nnz_idx = find(rows_summed_pre);

bbx_width = cols_nnz_idx(end) - cols_nnz_idx(1);

bbx_height = rows_nnz_idx(end) - rows_nnz_idx(1);

if do_plot, imagesc(im_labeled); pause(pause_time), end

% Try to get good threshold for removing noise segments of size < thr
label_thr = bbx_width * bbx_height * 0.0025 + 1;

for label = 1:nbr_labels
    curr_img = (im_labeled == label);
    
    % remove all segments that are too small
    if sum(curr_img, 'all') < label_thr
        im_labeled = im_labeled - curr_img * label;
    end
    
end

% Convert back to binary
im = im_labeled ~= 0;

% Segment into 5 by splitting at empty columns

if do_plot, imagesc(im_labeled); pause(pause_time), end

cols_summed = sum(im, 1);
curr_row = 1;
buffer = 1;

try

    for img_idx = 1:5
        
        % go to first column that is not 0
        while (cols_summed(curr_row) == 0)
            curr_row = curr_row + 1;
        end
        
        idx_start = curr_row - buffer;
        
        % go to first column that is zero
        while (cols_summed(curr_row) ~= 0)
            curr_row = curr_row + 1;
        end
        
        idx_end = curr_row + buffer;
    
        % add img to cell
        im_seg = im(:, idx_start:idx_end);
        S{img_idx}(:, idx_start:idx_end) = im_seg;
    
    end

catch e
    rethrow(e)
end


end