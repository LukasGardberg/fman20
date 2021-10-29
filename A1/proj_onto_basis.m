function [u_p, error] = proj_onto_basis(u, bases)
% PROJ_ONTO_BASIS 
% Projects the vector (matrix) u onto vectors in 'basis_vectors'
% 
% u: M x N matrix
%
% bases: M x N x B matrix , where B is the number of basis vectors
% We assume all basis vectors to be orthonormal

% Makes sure u and bases are of same shape
assert(all(size(u) == size(bases(:,:,1))), 'wrong sizes')

nbr_bases = size(bases, 3);
[rows, cols] = size(u);

% initialize projected u
u_p = zeros(rows, cols);

% project u onto each basis vector, and sum
for i = 1:nbr_bases
    
    base_temp = bases(:,:,i);
    u_p = u_p + scalar_prod(u, base_temp)*base_temp;
    
end

error = sqrt(scalar_prod(u-u_p, u-u_p));

end

% scalar product helper function
function s = scalar_prod(A, B)
    % A, B assumed to be compatible matrices
    
    rows = size(A, 1);
    cols = size(A, 2);
    
    s = 0;
    
    for row = 1:rows
        for col = 1:cols
            s = s + A(row, col)*B(row,col);
        end
    end
end
