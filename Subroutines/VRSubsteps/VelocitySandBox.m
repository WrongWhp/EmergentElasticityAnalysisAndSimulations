




clear mean_manip_traj_scores;
clear mean_manip_trial_lengths;
clear mean_mouse_count_array;

for i_struct = 1:length(filtered_ratemap_list)
    
    mean_mouse_count_array(i_struct, :) = mean(cur_ratemap_struct.vr_firing_rate_arrays.smoothed_mouse_count_array);
    
    cur_ratemap_struct = filtered_ratemap_list{i_struct};
    cur_manip_list = cur_ratemap_struct.manipulation_trial;
    mean_manip_traj_scores(i_struct) = mean(cur_ratemap_struct.traj_velocity_scores(cur_manip_list>0));
    mean_manip_trial_lengths(i_struct) = mean(cur_ratemap_struct.trial_lengths(cur_manip_list>0));
    
    
    cur_firing_rate = cur_ratemap_struct.vr_firing_rate_arrays.smoothed_firing_rate_array;
    firing_rates_by_trial = mean(cur_firing_rate, 2);
    
    non_manip_trial = find(~cur_ratemap_struct.manipulation_trial);
    x_to_use = cur_ratemap_struct.traj_velocity_scores(non_manip_trial);
    y_to_use =  firing_rates_by_trial(non_manip_trial)'
    scatter(x_to_use, y_to_use);
    corr_matrix = corrcoef(x_to_use, y_to_use);
    
    cov_matrix = cov(x_to_use/mean(x_to_use), y_to_use/mean(y_to_use));
    cur_corr = corr_matrix(2,1);
    cur_cov = cov_matrix(2,1);
    
    corr_list(i_struct) = cur_corr;
    cov_list(i_struct) = cur_cov;
    
    poly_fit = polyfit(x_to_use/mean(x_to_use), y_to_use/mean(y_to_use), 1);
    poly_list(i_struct) = poly_fit(1);
    
    title(cur_corr);
%    pause;
    close all;
end