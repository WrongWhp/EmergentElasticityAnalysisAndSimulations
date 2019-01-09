%Prints the conditional distribution of attractor states in the center of
%the box. Simple way to quantify path-dependent shifts.


%We choose a few  pixels around the center one for slightly better
%resolution
center_iY = median(system.mesh.iY(system.in_bounds));
center_iX = median(system.mesh.iX(system.in_bounds));


log_range = [-1:1];
%log_range = -2:2; %Not sure if I can make it something else or if this part of the code doesn't work

for cur_cond = 1:8
    
    
    for log_i = 1:length(log_range)
        for log_j = 1:length(log_range)
%            log_i
%            log_j
            cond_rh_slice = system.cond_rh_accum(log_i + center_iY,log_j + center_iX , :, :, cur_cond);
            cur_pixel_permuted_cond_dist = permute(cond_rh_slice, [3 4 1 2]);
            
            %            iX, iY
            all_pixel_permuted_cond_dist(:, :, log_i, log_j) = cur_pixel_permuted_cond_dist/sum(cur_pixel_permuted_cond_dist(:));
            %Normalize each one by the total weight. This prefents
            %"shifts by smoothing" effects.
        end
    end
        mean_all_pixel_permuted_cond_dist = mean(mean(all_pixel_permuted_cond_dist, 3), 4);
    
    
    if(0)
        close all
        imshow(mean_all_pixel_permuted_cond_dist/max(mean_all_pixel_permuted_cond_dist(:)));
        pause;
    end
    
    if(sum(mean_all_pixel_permuted_cond_dist(:)) > 0)
%        averaged_conds = sum(sum(mean_all_pixel_permuted_cond_dist, 3), 4);
        cond_center_of_box_vu(run_num, cur_cond, :) = RhDistArray2VU(mean_all_pixel_permuted_cond_dist, size(mean_all_pixel_permuted_cond_dist, 1));
    end
end



