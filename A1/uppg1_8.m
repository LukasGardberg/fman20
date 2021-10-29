load('assignment1bases.mat')

nbr_test_sets = size(stacks,2);
nbr_bases = size(bases,2);

error_means = zeros(nbr_test_sets, nbr_bases);

for set = 1:nbr_test_sets
    
    for base = 1:nbr_bases
        vectors = stacks{set};
        nbr_vectors = length(vectors);
        
        total_error = 0;
        for v = 1:nbr_vectors
            [u_p, error] = proj_onto_basis(vectors(:,:,v), bases{base});
            total_error = total_error + error;
        end
        
        error_means(set, base) = total_error / nbr_vectors;
        
    end
    
    
end

%% Plots 

figure(1)
for i = 1:4
    subplot(3,4,i)
    imagesc(bases{1}(:,:,i));
    
    subplot(3,4,i+4)
    imagesc(bases{2}(:,:,i));
    
    subplot(3,4,i+8)
    imagesc(bases{3}(:,:,i));
end

colormap(gray)

figure(2)


for j = 1:5
    n = randi(400);
    
    im_1 = stacks{1}(:,:,n);
    im_2 = stacks{2}(:,:,n);
    
    subplot(2,5,j)
    imagesc(im_1)

    subplot(2,5,j+5)
    imagesc(im_2)

end

colormap(gray)
