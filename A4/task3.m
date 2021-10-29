a1 = [0, -2];
a2 = [-3, 0];
a3 = [-2, -4];

a = [a1', a2', a3';
      1,  1,   1];

b1 = [-8, -2];
b2 = [0, 3];
b3 = [4, 1];

b = [b1', b2', b3';
      1,   1,   1];

F = [2, 2, 4;
     3, 3, 6;
     -5, -10, -6];

% If x and y are in correspondence, x' * F * y = 0
res = zeros(3);

for i = 1:3
    for j = 1:3
        res(i, j) = b(:, i)' * F * a(:, j); 
    end
end

