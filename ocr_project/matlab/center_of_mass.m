function center = center_of_mass(im)
% im: binary matrix

[rows, cols] = size(im);
total_mass = sum(im, 'all');

center_row = 0;
for col = 1:cols
    center_row = center_row + sum(im(:,col)) * col;
end

center_col = 0;
for row = 1:rows
   center_col = center_col + sum(im(row, :)) * row;
end

center = [center_row, center_col] / total_mass;

center = round(center);

end