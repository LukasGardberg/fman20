function S = im2segment(im, threshold)
% Takes in an image 'im' containing several
% square images which are segmented through thresholding

% Default threshold value
if nargin < 2
    threshold = 36;
end

m = size(im,1); % height
n = size(im,2); % width

% Assume individual images square
nrofsegments = n / m;

S = cell(1,nrofsegments);

% Segment each square image
for kk = 1:nrofsegments
    % Pixel indices for image 'kk'
    start_index = 1 + (kk - 1)*m;
    end_index = m * kk;
    
    curr_img = im(:, start_index:end_index);
    
    % Creates logical segmented image by thresholding
    segmented_img = curr_img > threshold;
    
    % Create full size image, place segmented in right spot
    S{kk} = zeros(m, n);
    S{kk}(:, start_index:end_index) = segmented_img;
end
