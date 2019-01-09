

clear gain_nongain_xcorr
clear gain_nongain_basesub_xcorr
clear xcorr_matrix
clear mouse_count_matrix
close all





clear mean_manip_traj_scores;
clear mean_manip_trial_lengths;

for i_struct = 1:length(filtered_ratemap_list)
    cur_ratemap_struct = filtered_ratemap_list{i_struct};
    cur_manip_list = cur_ratemap_struct.manipulation_trial;
    mean_manip_traj_scores(i_struct) = mean(cur_ratemap_struct.traj_velocity_scores(cur_manip_list>0));
    mean_manip_trial_lengths(i_struct) = mean(cur_ratemap_struct.trial_lengths(cur_manip_list>0));
    if(1)
        %Separate in to manip and no manip conditions
        manip_label_list = cur_manip_list + 1;
        %    manip_label_list(and(cumsum(cur_manip_list)>0, manip_label_list == 1)) = 3;
    elseif(1)
        %Separate into manip, near manip, and far from manip conditions.         
        manip_label_list = cur_manip_list + 1;
        close_to_manip =(imfilter(cur_manip_list, ones([7 7]))>0);
        close_to_manip_not_manip = and(close_to_manip, ~cur_manip_list);
        far_from_manip_not_manip = and(~close_to_manip, ~cur_manip_list);
        
        
        manip_label_list(close_to_manip_not_manip) = 1;
        manip_label_list(far_from_manip_not_manip) = 3;
                        
    else
        %Sorts t by mouse vleocity
        manip_label_list = 3  + 0 * cur_manip_list;
        median_traj_score = median(cur_ratemap_struct.traj_velocity_scores(cur_manip_list>0));

        max_traj_score = max(cur_ratemap_struct.traj_velocity_scores(cur_manip_list>0));
        min_traj_score = min(cur_ratemap_struct.traj_velocity_scores(cur_manip_list>0));
        
        if(1)
            manip_label_list(and(cur_manip_list>0, cur_ratemap_struct.traj_velocity_scores'>median_traj_score)) = 1;
            manip_label_list(and(cur_manip_list>0, cur_ratemap_struct.traj_velocity_scores'<median_traj_score)) = 2;
        else
            manip_label_list(and(cur_manip_list>0, cur_ratemap_struct.traj_velocity_scores' == max_traj_score)) = 1;
            manip_label_list(and(cur_manip_list>0, cur_ratemap_struct.traj_velocity_scores'== min_traj_score)) = 2;
        end
    end
    for manip_label = 1:max(manip_label_list)
        correct_manipulation_mask = manip_label_list == manip_label;
        single_trial_mean_firing_rates = (cur_ratemap_struct.vr_firing_rate_arrays.smoothed_firing_rate_array(find(correct_manipulation_mask), :));
        cell_trial_mean_firing_rate(i_struct, manip_label) = mean(mean(single_trial_mean_firing_rates));
        fft_manip{manip_label} = fft2(single_trial_mean_firing_rates);
        
        mean_mouse_count{manip_label} = mean(cur_ratemap_struct.vr_firing_rate_arrays.smoothed_mouse_count_array(find(correct_manipulation_mask), :), 1);
        mean_spike_count{manip_label} = mean(cur_ratemap_struct.vr_firing_rate_arrays.smoothed_spike_count_array(find(correct_manipulation_mask), :), 1);
        mean_firing_rate{manip_label} = mean_spike_count{manip_label}./mean_mouse_count{manip_label};
        mean_firing_rate{manip_label} =  mean_firing_rate{manip_label}/mean(mean_firing_rate{manip_label});
        %        fprintf('Mean mouse count is %f \n', mean(mean_mouse_count));
    end
    if(1)
        cur_gain_non_gain_xcorr = xcorr2(mean_firing_rate{1}, mean_firing_rate{2});
        x_corr_cube(:, :, i_struct) = (mean_firing_rate{1} - mean(mean_firing_rate{1}))' * (mean_firing_rate{2} - mean(mean_firing_rate{2}));
%        x_corr_cube(:, :, i_struct) = (mean_firing_rate{1} - mean(mean_firing_rate{1}))' * (mean_firing_rate{1} - mean(mean_firing_rate{1}));

        gain_nongain_xcorr_array(:, i_struct) = cur_gain_non_gain_xcorr;
    end
    
    if(0)
        fft_1 =fft_manip{1};
        center_1 = fft_1(round(.5 * (1 + size(fft_1, 1))), :);
        fft_2 = fft_manip{2};
        center_2 = fft_2(round(.5 * (1 + size(fft_2, 1))), :);
        plot(abs(center_1(1:30)));
        hold on;
        plot(abs(center_2(1:30)));
        pause;
        close all;
        
    end
    if(0)
        close all;
        f1 = abs(fft(mean_firing_rate{1}))
        f2 = abs(fft(mean_firing_rate{2}))
        plot(f1(1:40));
        hold on;
        plot(f2(1:40));
        pause;
        close all;
        
    end
    
end


shift_scores = (gain_nongain_xcorr_array(205, :) - gain_nongain_xcorr_array(195, :))./gain_nongain_xcorr_array(200, :);
x_shift = 2 * (-199:199);

base_sub_x_corr_array = gain_nongain_xcorr_array - repmat(gain_nongain_xcorr_array(find(x_shift == 0) + 0, :), [length(x_shift) 1]);

matrix_to_use = base_sub_x_corr_array;
%matrix_to_use = gain_nongain_xcorr_array;

%errorbar(x_shift, nanmean(gain_nongain_xcorr, 2), nanstd(gain_nongain_xcorr, 0,2));
std_to_use = nanstd(matrix_to_use, 0,2)./ sqrt(sum(~isnan(matrix_to_use), 2));
values_to_use = nanmean(matrix_to_use, 2);

my_x_lim = 100;
fewer_inds = 1:1:length(x_shift);
fewer_inds = fewer_inds(abs(x_shift(fewer_inds))<my_x_lim);
errorbar(x_shift(fewer_inds), values_to_use(fewer_inds), std_to_use(fewer_inds));

xlabel('Delta X');
ylabel('Cell-Averaged Correlation');
hold on;
scatter(x_shift(fewer_inds), values_to_use(fewer_inds), '.k');
xlim(my_x_lim * [-1 1]);

