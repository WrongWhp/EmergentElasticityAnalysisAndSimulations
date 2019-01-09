

clear gain_nongain_xcorr
clear gain_nongain_basesub_xcorr
clear xcorr_matrix
clear mouse_count_matrix
close all
clear mean_manip_traj_scores;
clear mean_manip_trial_lengths;

for i_struct = 1:length(filtered_ratemap_list)
    close all;
    cur_ratemap_struct = filtered_ratemap_list{i_struct};
    cur_manip_list = cur_ratemap_struct.manipulation_trial;
    mean_manip_traj_scores(i_struct) = mean(cur_ratemap_struct.traj_velocity_scores(cur_manip_list>0));
    mean_manip_trial_lengths(i_struct) = mean(cur_ratemap_struct.trial_lengths(cur_manip_list>0));
    
    manip_label_list = cur_manip_list + 1;
    close_to_manip =(imfilter(cur_manip_list, ones([7 7]))>0);
    close_to_manip_not_manip = and(close_to_manip, ~cur_manip_list);
    far_from_manip_not_manip = and(~close_to_manip, ~cur_manip_list);
    manip_label_list(manip_label_list==1 .* (cumsum(cur_ratemap_struct.manipulation_trial)>0)) = 3;
    
    last_manip_trial = max(find(cur_ratemap_struct.manipulation_trial));
    
    for posit_slice_ind = 1:2        
        for time_slice_ind = 1:2
            
            subplot(2, 2, posit_slice_ind*2 + time_slice_ind - 2);
            posit_slices = (1:80) + 10 + (posit_slice_ind-1) * 100;
            time_slices = last_manip_trial + 1 + (1:10) + (time_slice_ind-1) * (cur_ratemap_struct.n_trials -last_manip_trial - 11);
            cur_subset = cur_ratemap_struct.vr_firing_rate_arrays.smoothed_firing_rate_array(time_slices, posit_slices);
            cur_x_corr = xcorr2(cur_subset);
            x_corr_mesh = MakeMeshFromArray(cur_x_corr);
            x_corr_mask = x_corr_mesh.x .* exp(-(x_corr_mesh.x/10).^2) .* (x_corr_mesh.y>0);
            x_corr_norm_mask =exp(-(x_corr_mesh.x/10).^2) .* (x_corr_mesh.y>0);
            
            imagesc(cur_x_corr);    
            title(sprintf('Time %d Posit %d', posit_slice_ind, time_slice_ind));
            
            shift_mag_cube(posit_slice_ind, time_slice_ind, i_struct) = sum(sum(cur_x_corr.*x_corr_mask))./sum(sum(cur_x_corr.*x_corr_norm_mask));
            
            
        end        
    end
    pause(1);
    close all;
    
    

end

close all

scatter(shift_mag_cube(1, 1, :), shift_mag_cube(1, 2, :))
title('Early Posit Varying Time');
pause;
close all;

scatter(shift_mag_cube(2, 1, :), shift_mag_cube(2, 2, :))
title('Late Posit Varying Time');
pause;
close all;



scatter(shift_mag_cube(1, 1, :), shift_mag_cube(2, 1, :))
title('Early Time Varying Posit');
pause;
close all;




scatter(shift_mag_cube(1, 2, :), shift_mag_cube(2, 2, :))
title('Late Time Varying Posit');
pause;
close all;








