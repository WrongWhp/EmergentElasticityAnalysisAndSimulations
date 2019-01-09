%Trying to make vibrational models in a two-box thing.
close all;
clear all;


mask = ones(30, 30);
mask(5:6, 6:25) = 0;
mask(5:30, 15:16) = 0;
imshow(mask);

delta_x_list = [0 1];
delta_y_list = [1 0];

cur_ind = 1;
ind_array = mask;
ind_array(find(mask)) = 1:(length(find(mask)));

matrix_to_solve = zeros(length(find(mask)));

small_laplacian  = ones(2) - 2* eye(2);

for x = 1:30
    for y = 1:30
        cur_ind = ind_array(y, x);
        for i_delta = 1:2
            
            neighbor_x = x + delta_x_list(i_delta);
            neighbor_y = y + delta_y_list(i_delta);
            if(neighbor_x<=30)
                if(neighbor_y<=30)
                    if(mask(y, x))
                        if(mask(neighbor_y, neighbor_x))
                            
                            neighbor_ind = ind_array(neighbor_y, neighbor_x);                            
                            
                            
                            matrix_to_solve(cur_ind, cur_ind) = matrix_to_solve(cur_ind, cur_ind)-1;
                            matrix_to_solve(neighbor_ind, cur_ind) = matrix_to_solve(neighbor_ind, cur_ind)+1;
                            matrix_to_solve(cur_ind, neighbor_ind) = matrix_to_solve(cur_ind, neighbor_ind)+1;
                            matrix_to_solve(neighbor_ind, neighbor_ind) = matrix_to_solve(neighbor_ind, neighbor_ind)-1;
                            
                            %matrix_to_solve([cur_ind neighbor_ind], [cur_ind neighbor_ind]) = matrix_to_solve([cur_ind neighbor_ind], [cur_ind neighbor_ind]) + small_laplacian;
                            
                        end
                    end
                end
            end
            
        end
    end
end



[eig_vec, eig_val] = eig(-matrix_to_solve);

for eig_val_ind = 1:500
    close all
    
    eig_val_ind
%   cur_eig_val = eig_vec(eig_val_ind, :);
   cur_eig_vec = eig_vec(:, eig_val_ind);

   thing_to_show = ind_array * nan;
   thing_to_show(find(mask)) = cur_eig_vec;
    [nr,nc] = size(thing_to_show)
   
%   mesh_arra
%   mesh(x
%    pcolor([thing_to_show nan(nr,1); thing_to_show(1,nc+1)]);

    minv = min(min(thing_to_show));
    maxv = max(max(thing_to_show));

    thing_to_show(isnan(thing_to_show)) = minv-((maxv-minv)/50);
    my_jet = jet(150);
    ddd=[0 0 0;my_jet(15:135, :)];
    colormap(ddd);

   imagesc(thing_to_show);
   fprintf('Eigenvalue is %.4e \n', eig_val(eig_val_ind, eig_val_ind));
   pause;
   
end




