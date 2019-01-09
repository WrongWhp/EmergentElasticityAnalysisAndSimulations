
clear sing_run_x_corr_arrays;
close all;

delta_trial_lim = 28;
delta_iX_lim = 20;
delta_trial_slice = round(delta_trial_lim * 1.9);
sing_run_x_corr_arrays = zeros(2*delta_trial_lim + 1, 2 * delta_iX_lim+1,1,1);
gain_manip_titles = {'Pre Gain Manip', ' Gain Manip', 'Post Gain Manip'}



for i_struct = 1:length(filtered_ratemap_list)
    fprintf('Doing struct %d/%d \n', i_struct, length(filtered_ratemap_list));
    cur_ratemap_struct = filtered_ratemap_list{i_struct};
    cur_manip_list = cur_ratemap_struct.manipulation_trial;
    
    fr_to_use = cur_ratemap_struct.vr_firing_rate_arrays.smoothed_firing_rate_array;
    fr_to_use(isnan(fr_to_use)) = 0;
    [x_corr, xc_delta_x, xc_delta_trial] = XCorrWithDeltas(fr_to_use, fr_to_use);
    x_corr(find(abs(xc_delta_trial) == 0), :) = 0;
    x_corr = x_corr/max(x_corr(:));
     output_path = sprintf('%s/SingleRunCrossCorr/WithinTrial%d.png', ap.output_path, i_struct);

    if(1)
        subplot(2,1, 1);
        imagesc(fr_to_use);
        
        subplot(2,1, 2);
        
        imagesc(x_corr);
        MakeFilePath(output_path)
        saveas(1, output_path);
        pause(.5)
    end
    
    cropped_x_corr = x_corr(find(abs(xc_delta_trial)<=delta_trial_lim), find(abs(xc_delta_x)<=delta_iX_lim));
    cropped_x_corr = cropped_x_corr - cropped_x_corr(delta_trial_slice, delta_iX_lim+1);
    
    sing_run_x_corr_arrays(:, :, i_struct) = cropped_x_corr;
end



subplot(2, 1, 1);

error_bars_sc = nanstd(sing_run_x_corr_arrays(:, :, :), 0, 3)/sqrt(length(filtered_ratemap_list));
to_image_sc = nanmean(sing_run_x_corr_arrays(:, :, :), 3);
imagesc(to_image_sc);
%title(gain_manip_titles{manip_label});
subplot(2, 1, 2);
errorbar(-delta_iX_lim:delta_iX_lim, to_image_sc(delta_trial_slice, :), error_bars_sc(delta_trial_slice, :)  );
     output_path = sprintf('%s/SingleRunCrossCorr/AverageWithinAllTrials.png', ap.output_path);
MakeFilePath(output_path)
        saveas(1, output_path);
        pause(.5);
