

clear gain_nongain_xcorr
clear gain_nongain_basesub_xcorr
clear xcorr_matrix
clear mouse_count_matrix


for i_struct = 1:length(filtered_ratemap_list)
    cur_ratemap_struct = filtered_ratemap_list{i_struct};
    
    [tmp f_name tmp] = fileparts(cur_ratemap_struct.path);
    fprintf('Got here! Using ratemap struct with key %s \n', f_name);
    
    %            fprintf('Got here! Using ratemap struct, gain is %f \n', cur_ratemap_struct.gain_value);
    
    gain_mouse_counts{1} =cur_ratemap_struct.vr_firing_rates{1}.purely_binned_rate * 0;
    gain_mouse_counts{2} = cur_ratemap_struct.vr_firing_rates{1}.purely_binned_rate * 0;
    
    gain_spike_counts{1} = cur_ratemap_struct.vr_firing_rates{1}.purely_binned_rate * 0;
    gain_spike_counts{2} = cur_ratemap_struct.vr_firing_rates{1}.purely_binned_rate * 0;
    
    
    %             gain_rate_maps{1} = cur_ratemap_struct.vr_firing_rates{1}.purely_binned_rate * 0;
    %             gain_rate_maps{2} = cur_ratemap_struct.vr_firing_rates{1}.purely_binned_rate * 0;
    
    gain_manip_trial_lengths= cur_ratemap_struct.trial_lengths(cur_ratemap_struct.manipulation_trial == 1);
    
    
    if(1)
        firing_rate_matrix = zeros(cur_ratemap_struct.n_bins, 0);
        
        for trial_num = 1:(length(cur_ratemap_struct.vr_firing_rates))
            if(~cur_ratemap_struct.manipulation_trial(trial_num))
                firing_rate_to_use = cur_ratemap_struct.vr_firing_rates{trial_num}.smoothed_firing_rate;
                firing_rate_to_use = firing_rate_to_use-nanmean(firing_rate_to_use);
                firing_rate_to_use = firing_rate_to_use/sqrt(nansum(firing_rate_to_use.^2));
                if(sum(isnan(firing_rate_to_use))==0)
                    firing_rate_matrix(:, size(firing_rate_matrix, 2) + 1) = cur_ratemap_struct.vr_firing_rates{trial_num}.smoothed_firing_rate;
                end
            end
        end
        cur_trialnumber_x_corr =  InteriorRectangle(xcorr2(firing_rate_matrix', firing_rate_matrix'), [18 180]);
        cur_trialnumber_x_corr(round(.5 * size(cur_trialnumber_x_corr, 1) + .5), :) = 0;
        
        imagesc(cur_trialnumber_x_corr);
        trial_number_xcorr_cube(:, :, i_struct) = cur_trialnumber_x_corr;
        pause(1);
        
    end
    for trial_num = 1:(length(cur_ratemap_struct.vr_firing_rates))
        
        if(1)
            %Gompare gain manipulated to non-gain manipulated
            gain_manip_ind = cur_ratemap_struct.manipulation_trial(trial_num) + 1;
            %                     gain_rate_maps{gain_manip_ind} = gain_rate_maps{gain_manip_ind} + cur_ratemap_struct.vr_firing_rates{trial_num}.smoothed_firing_rate;
            
            gain_mouse_counts{gain_manip_ind} = gain_mouse_counts{gain_manip_ind} + cur_ratemap_struct.vr_firing_rates{trial_num}.smoothed_mouse_count;
            gain_spike_counts{gain_manip_ind} = gain_spike_counts{gain_manip_ind} + cur_ratemap_struct.vr_firing_rates{trial_num}.smoothed_spike_count;
            
        elseif(0)
            
            
        else
            
            
            if(cur_ratemap_struct.manipulation_trial(trial_num))
                cur_trial_length = cur_ratemap_struct.trial_lengths(trial_num);
                gain_manip_ind = (cur_trial_length < median(gain_manip_trial_lengths)) + 1;
                
                gain_mouse_counts{gain_manip_ind} = gain_mouse_counts{gain_manip_ind} + cur_ratemap_struct.vr_firing_rates{trial_num}.smoothed_mouse_count;
                gain_spike_counts{gain_manip_ind} = gain_spike_counts{gain_manip_ind} + cur_ratemap_struct.vr_firing_rates{trial_num}.smoothed_spike_count;
                
                fprintf('Got here at trial number %d gain manip %d \n', trial_num, gain_manip_ind);
                
                
            end
        end
        
        for gain_manip_ind = 1:2
            gain_rate_maps{gain_manip_ind} =  gain_spike_counts{gain_manip_ind} ./gain_mouse_counts{gain_manip_ind};
            gain_rate_maps{gain_manip_ind} = gain_rate_maps{gain_manip_ind} - nanmean(gain_rate_maps{gain_manip_ind});
            gain_rate_maps{gain_manip_ind}  = gain_rate_maps{gain_manip_ind}/sqrt(nanmean(gain_rate_maps{gain_manip_ind}.^2 ));
            gain_rate_maps{gain_manip_ind}(isnan(gain_rate_maps{gain_manip_ind})) = 0;
        end
        
        
        
        
        
        %                assert(false, 'shouldfail');
        
    end
    mean_firing_matrix(:, i_struct) = gain_rate_maps{1};
    cur_gain_nongain_xcorr = xcorr( gain_rate_maps{2}, gain_rate_maps{1});
    cur_base_subtracted_gng_xcorr = cur_gain_nongain_xcorr - cur_gain_nongain_xcorr(ceil(length(cur_gain_nongain_xcorr)/2));
    
    mouse_count_matrix(:, i_struct) = gain_mouse_counts{1}/mean(gain_mouse_counts{1});
    xcorr_matrix(:, :,i_struct)  = gain_rate_maps{1} * gain_rate_maps{2}';
    
    gain_nongain_xcorr( :, i_struct) = cur_gain_nongain_xcorr;
    gain_nongain_basesub_xcorr(:, i_struct)= cur_base_subtracted_gng_xcorr;
    
    mean_trial_lengths(i_struct) = mean(gain_manip_trial_lengths);
    
    
    
end





close all;
imagesc(mean(trial_number_xcorr_cube, 3))
title('Cross trial correlation');
pause;
close all
x_shift = (1:size(gain_nongain_xcorr, 1)) -size(gain_nongain_xcorr, 1)/2 -.5;


%    matrix_to_use = gain_nongain_xcorr;
matrix_to_use = gain_nongain_basesub_xcorr;



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

foo = gain_nongain_basesub_xcorr(198, :) - gain_nongain_basesub_xcorr(202, :);
a= signFlipPValue(foo);
pause;
close all

mean_mouse_count = nanmean(mouse_count_matrix, 2);
mean_cross_corr_matrix = nanmean(xcorr_matrix, 3);
imagesc(mean_cross_corr_matrix);
[my_mesh.iX, my_mesh.iY] =meshgrid(1:size(mean_cross_corr_matrix, 1), 1:size(mean_cross_corr_matrix, 1));
%    my_dummy_matrix = ones(size(mean_cross_corr_matrix));
my_mask = abs(my_mesh.iX - my_mesh.iY)>25;
mean_cross_corr_matrix(my_mask) = 0;
%    my_dummy_matrix(my_mask) = 0;

for my_mean = 1:max(my_mesh.iX(:))
    mesh_mean = .5 *(my_mesh.iX+ my_mesh.iY);
    mesh_diff = my_mesh.iX - my_mesh.iY;
    mesh_mean_mask = mesh_mean == my_mean;
    my_mask_weights = mean_cross_corr_matrix(mesh_mean_mask);%Diagonal slice
    
    
    my_mask_weights(my_mask_weights<0) = 0;
    my_mask_diffs = mesh_diff(mesh_mean_mask);
    weighted_diff(round(my_mean)) = sum(my_mask_weights .* my_mask_diffs)/sum(my_mask_weights);
end