ev_1 = 1/3 * [0, 1, 0; 1, 1, 1; 1, 0, 1; 1, 1, 1];
ev_2 = 1/2 * [0, 0, 0; 0, 0, 0; 1, 0, -1; 1, 0, -1];
ev_3 = 1/2 * [1, 0, -1; 1, 0, -1; 0, 0, 0; 0, 0, 0];
ev_4 = 1/3 * [1, 1, 1; 1, 0, 1; -1, -1, -1; 0, -1, 0];


evs = {ev_1, ev_2, ev_3, ev_4};
%% Scalar product between basis images
prods = zeros(4,4);

for row = 1:4
    for col = 1:4
       
        prods(row, col) = scalar_prod(evs{row}, evs{col});
        
    end 
end

prods

%% Determine projected f onto subspace and coordinates

f = [-2, 6, 3; 13, 7, 5; 7, 1, 8; -3, 4, 4];

% Project f onto all basis vectors, then add up projections

projs = {};
coords = zeros(4, 1);
res = zeros(4, 3);

for i = 1:4
    
    coords(i) = scalar_prod(f, evs{i});
    projs{i} = coords(i) * evs{i};
    
    res = res + projs{i};
    
end

res
m_norm(f-res)
%% Sanity check

rands = 20 * rand(4,1)-10;

f_test = rands(1)*evs{1} + rands(2)*evs{2} + rands(3)*evs{3} + rands(4)*evs{4};
m_norm(f-f_test)

% All of these randomly generated images are further away from f than f_a
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

function n = m_norm(A)
    n = sqrt(scalar_prod(A,A));
end