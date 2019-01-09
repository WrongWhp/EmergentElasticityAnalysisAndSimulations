

clear gain_nongain_xcorr
clear gain_nongain_basesub_xcorr
clear xcorr_matrix
clear mouse_count_matrix
clear inter_trial_repeatibility
clear x_corr
close all

clear inter_x_corr_arrays



delta_trial_lim = 4;
delta_iX_lim = 20;
delta_trial_slice = 7;
delta_trial_slice_list = [ 7 7];
inter_x_corr_arrays = zeros(2*delta_trial_lim + 1, 2 * delta_iX_lim+1,1,1);
gain_manip_titles = {'Pre Gain Manip', ' Gain Manip', 'Post Gain Manip'}

clear delta_trial_averaged_array;



for i_struct = 1:length(filtered_ratemap_list)
    
    fprintf('Doing struct %d/%d \n', i_struct, length(filtered_ratemap_list));
    cur_ratemap_struct = filtered_ratemap_list{i_struct};
    cur_manip_list = cur_ratemap_struct.manipulation_trial;
    
    manip_label_list = cur_manip_list + 1;
    manip_label_list(and(cumsum(cur_manip_list)>0, manip_label_list == 1)) = 3;
    
    if(1)
        for manip_label = 1:max(manip_label_list)
            correct_manipulation_mask = manip_label_list == manip_label;
            mean_firing_rate_sub_array = cur_ratemap_struct.vr_firing_rate_arrays.smoothed_firing_rate_array(find(correct_manipulation_mask), :);
            mean_firing_rate_sub_array(isnan(mean_firing_rate_sub_array)) = 0;
            inter_trial_repeatibility(i_struct, manip_label) = IntertrialRepeatilibity(mean_firing_rate_sub_array);
        end
    end
    
    
    if(1)
        
        close all;
        subplot(4, 1, 1);
        imagesc(cur_ratemap_struct.vr_firing_rate_arrays.smoothed_firing_rate_array);
        title('Firing Rate Vs Trial, X');
        
        for manip_label = 1:max(manip_label_list)
            correct_manipulation_mask = manip_label_list == manip_label;
            subplot(4, 1, manip_label+1);
            mean_firing_rate_sub_array = cur_ratemap_struct.vr_firing_rate_arrays.smoothed_firing_rate_array(find(correct_manipulation_mask), :);
            mean_firing_rate_sub_array(isnan(mean_firing_rate_sub_array)) = 0;
            [x_corr{manip_label}, xc_delta_x, xc_delta_y] = XCorrWithDeltas(mean_firing_rate_sub_array, mean_firing_rate_sub_array);
            to_image_sc = x_corr{manip_label};
            to_image_sc(round(size(to_image_sc, 1) +1)/2, :)  = 0;
            imagesc(to_image_sc);
            title(gain_manip_titles{manip_label});
            
            cropped_cross_corr = to_image_sc(find(abs(xc_delta_y)<= delta_trial_lim), find(abs(xc_delta_x)<= delta_iX_lim));
            cropped_cross_corr_for_array = cropped_cross_corr/max(cropped_cross_corr(:));
            cropped_cross_corr_for_array = cropped_cross_corr_for_array - cropped_cross_corr_for_array(delta_trial_slice, delta_iX_lim+1);
            inter_x_corr_arrays(:, :, i_struct, manip_label) = cropped_cross_corr_for_array; %Hacky normalization-TODO FIx this
            
            
            cropped_delta_trial_averaged_cross_corr = mean(cropped_cross_corr(delta_trial_slice_list, :), 1);
            cropped_delta_trial_averaged_cross_corr = cropped_delta_trial_averaged_cross_corr -cropped_delta_trial_averaged_cross_corr(delta_iX_lim + 1);
            delta_trial_averaged_array(i_struct, :, manip_label) = cropped_delta_trial_averaged_cross_corr;
            
            %   inter_repeatilibity(i_struct, manip_label) = IntertrialRepeatilibity(mean_firing_rate_sub_array);
        end
        
        pause(.5);
        output_path = sprintf('%s/WithinManipCrossCorr/WithinTrial%d.png', ap.output_path, i_struct);
        MakeFilePath(output_path);
        saveas(1, output_path);
        %    pause;
        
    end
    
end

%%
if(0)
    close all;
    %fprintf('Inter-Trial repeabilibility is %f \n', nanmean(inter_trial_repeatibility));
    mean_repeatibility = nanmean(inter_trial_repeatibility);
    std_repeatibility = nanstd(inter_trial_repeatibility);
    close all;
    figure
    hold on
    bar(1:3,mean_repeatibility)
    errorbar(1:3,mean_repeatibility,std_repeatibility,'.')
    pause;
else
    pre_during_post_array = inter_trial_repeatibility;
    PrePostDuringCompare
end

%% Mean Cross Corr For Each of the conditions

close all;
if(1)
    for manip_label = 1:max(manip_label_list)
        correct_manipulation_mask = manip_label_list == manip_label;
        subplot(3, 2, 2*manip_label-1);
        
        error_bars_sc = nanstd(inter_x_corr_arrays(:, :, :, manip_label), 0, 3)/sqrt(length(filtered_ratemap_list));
        
        to_image_sc = nanmean(inter_x_corr_arrays(:, :, :, manip_label), 3);
        imagesc(to_image_sc);
        title(gain_manip_titles{manip_label});
        subplot(3, 2, 2*manip_label);
        
        errorbar(-delta_iX_lim:delta_iX_lim, nanmean(delta_trial_averaged_array(:, :, manip_label), 1),nanstd(delta_trial_averaged_array(:, :, manip_label), 0, 1)/sqrt(length(filtered_ratemap_list)));
        
        %            errorbar(-delta_iX_lim:delta_iX_lim, to_image_sc(delta_trial_slice, :), error_bars_sc(delta_trial_slice, :)  );
        xlim(delta_iX_lim * [-1 1]);
        ylim([min(to_image_sc(delta_trial_slice, :)) (max(to_image_sc(delta_trial_slice, :))  + max(error_bars_sc(delta_trial_slice, :) ))]);
        hold on;
        
    end
    pause(.5);
    output_path = sprintf('%s/WithinManipCrossCorr/WithinTrialAllAveraged.png', ap.output_path);
    saveas(1, output_path);
    
    
end

return;
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

