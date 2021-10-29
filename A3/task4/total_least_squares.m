function p_tls = total_least_squares(x, y)
% Total least square estimation of 
% p_ls = [a, b, c] for ax + by + c = 0

% assume a^2 + b^2 = 1

N = length(x);

A = ones(2);

A(1,1) = sum(x.^2) - 1/N * sum(x)^2;
A(1,2) = sum(x.* y) - 1/N * sum(x)*sum(y);
% A(2,1) = sum(x.* y) - 1/N * sum(x)*sum(y);
A(2,1) = A(1,2); % Symmetric
A(2,2) = sum(y.^2) - 1/N * sum(y)^2;

[eig_vecs, eig_vals] = eig(A);

% eigs give two solutions, choose one with least error
a1 = eig_vecs(1,1);
b1 = eig_vecs(2,1);

p1 = [a1;
      b1;
     -1/N * (a1*sum(x) + b1*sum(y))];
 
error_1 = orth_error(p1(1), p1(2), p1(3), x, y);

a2 = eig_vecs(1,2);
b2 = eig_vecs(2,2);

p2 = [a2;
      b2;
      -1/N * (a2*sum(x) + b2*sum(y))];
  
error_2 = orth_error(p2(1), p2(2), p2(3), x, y);

[mins, idx] = min([error_1, error_2]);

if idx == 1
    p = p1;
else
    p = p2;
end

% convert to y = kx + m
p_tls = [-p(1)/p(2), -p(3)/p(2)];

end

function err = orth_error(a,b,c,x,y)
    err = 0;
    for i = 1:length(x)
        err = err + (a*x(i) + b*y(i) + c)^2;
    end

end

