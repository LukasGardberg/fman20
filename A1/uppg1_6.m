u = [4, -1; -2, 5];
v = 0.5 * [-1, 1; 1, -1];
w = 0.5 * [1, -1; 1, -1];

sqrt(scalar_prod(u,u))
sqrt(scalar_prod(v,v))
sqrt(scalar_prod(w,w))

scalar_prod(u, v) % -6
scalar_prod(u,w)
scalar_prod(v,w)

%% Project u onto v and w - plane

u2 = u(:);
v2 = v(:);
w2 = w(:);
u
u_onto_w = scalar_prod(u, w) * w; % w is normal
u_onto_v = scalar_prod(u, v) * v;

p = u_onto_w + u_onto_v;

diff = sqrt(scalar_prod(u-p, u-p))

d = sqrt(scalar_prod(u-w, u-w))

%%


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