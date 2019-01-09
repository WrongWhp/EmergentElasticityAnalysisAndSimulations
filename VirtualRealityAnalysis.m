close all
clear all
global ap;%%Short for analysis parameters

addAllPaths;
ap.data_dir_path = '../../../AllGridCellData/MalcolmVRData/MalcolmFull/';
%ap.data_dir_path = '../../../AllGridCellData/MalcolmVRData/MalcolmPartial/';
%all_data_paths = TraverseFreeRoamingData(ap.data_dir_path);
ap.output_path =  [ap.data_dir_path  '/Outputs/'];

MaybeOrganizeIntoMegaStruct;

MaybeConstructRateMaps

%% Trying to make a better datastructure
MakeAssortedRateMapFilters;
%rate_map_filter = malcolm_border_rate_filter;
rate_map_filter = malcolm_grid_rate_map_filter;
%rate_map_filter.gain_value = .5;
%rate_map_filter  = any_gain_manip_filter;
%rate_map_filter.session_type = 'cue_removal';
rate_map_filter.min_trials = 40;
rate_map_filter.gain_value = 1.5;
%rate_map_filter = rmfield(rate_map_filter, 'gain_value');

FilterRateMapStruct
%LookingForShortTermPlasticity
%MakeSingleRunCrossCorr

%MakeWithinManipCrossCorr
%MakeWithinManipCrossCorr;
%DeltaTrialAverageSandbox
MakeConditionNoConditionCrossCorrelelogram
%MakeSingleRunCrossCorr



assert(false, 'Should fail, wanted to end here');






%% Working on this bit (Backup)



cur_n_structs_used = 0;
clear gain_nongain_xcorr
clear gain_nongain_basesub_xcorr
clear xcorr_matrix
clear mouse_count_matrix



for cur_key  = mouse_cell_ratemap_megastruct.keys();
    fprintf('Doing key %s \n', cur_key{1});
    cur_output_path = sprintf('%s/%s/', ap.output_path, cur_key{1});
    cur_ratemap_struct_list = mouse_cell_ratemap_megastruct(cur_key{1});
    
    for run_number = 1:length(cur_ratemap_struct_list)
        cur_ratemap_struct = cur_ratemap_struct_list{run_number};
        %        fprintf('Session Type: %s \n', cur_ratemap_struct.session_type);
        %        cur_ratemap_struct.gain_value
        %        cur_ratemap_struct.manipulation_trial
        %        if(strcmp(cur_ratemap_struct.session_type, 'cue_removal') )
        %        if(strcmp(cur_ratemap_struct.session_type, 'optic_flow_track') )
        
        
        should_use_ratemap_struct = strcmp(cur_ratemap_struct.session_type, 'gain_manip');
        should_use_ratemap_struct = should_use_ratemap_struct && cur_ratemap_struct.gain_value == 1.5;
        should_use_ratemap_struct = should_use_ratemap_struct && cur_ratemap_struct.open_field_scores.grid_score>.2;
        should_use_ratemap_struct = should_use_ratemap_struct && cur_ratemap_struct.open_field_scores.border_score < .3;
        
        if(should_use_ratemap_struct)
            cur_n_structs_used = cur_n_structs_used+1;
            
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
                trial_number_xcorr_cube(:, :, cur_n_structs_used) = cur_trialnumber_x_corr;
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
            mean_firing_matrix(:, cur_n_structs_used) = gain_rate_maps{1};
            cur_gain_nongain_xcorr = xcorr( gain_rate_maps{2}, gain_rate_maps{1});
            cur_base_subtracted_gng_xcorr = cur_gain_nongain_xcorr - cur_gain_nongain_xcorr(ceil(length(cur_gain_nongain_xcorr)/2));
            
            mouse_count_matrix(:, cur_n_structs_used) = gain_mouse_counts{1}/mean(gain_mouse_counts{1});
            xcorr_matrix(:, :,cur_n_structs_used)  = gain_rate_maps{1} * gain_rate_maps{2}';
            
            gain_nongain_xcorr( :, cur_n_structs_used) = cur_gain_nongain_xcorr;
            gain_nongain_basesub_xcorr(:, cur_n_structs_used)= cur_base_subtracted_gng_xcorr;
            
            mean_trial_lengths(cur_n_structs_used) = mean(gain_manip_trial_lengths);
            
            
            
        end
        
        
        
    end
end

close all;
imagesc(mean(trial_number_xcorr_cube, 3))
title('Cross trial correlation');
pause;
c
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

%mean_mouse_count = nanmean(mouse_count_matrix, 2);


if(1)
    mean_cross_corr_matrix = nanmean(x_corr_cube, 3);
    mean_cross_corr_std = nanstd(x_corr_cube, [], 3);
    imagesc(mean_cross_corr_matrix);
    [my_mesh.iX, my_mesh.iY] =meshgrid(1:size(mean_cross_corr_matrix, 1), 1:size(mean_cross_corr_matrix, 1));
    %    my_dummy_matrix = ones(size(mean_cross_corr_matrix));
    my_mask = abs(my_mesh.iX - my_mesh.iY)>25;
%    mean_cross_corr_matrix(my_mask) = 0;

%    mean_cross_corr_matrix = mean_cross_corr_matrix .*exp( -( (my_mesh.iX - my_mesh.iY)/15).^2);
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
    pause;
    close all;
    plot(2 * (1:200), 2 * weighted_diff);
    
end
%    hold on;
%    plot(mean_mouse_count/nanmax(mean_mouse_count), 'k');
%    imagesc(mean_cross_corr_matrix);


%    my_COM = sum(mean_cross_corr_matrix .*my_mesh.iX, 2)./sum(mean_cross_corr_matrix, 2);

[~, arg_max] = max(mean_cross_corr_matrix);
pause;
close all
plot(arg_max);
hold on;
plot(1:200);



%%


assert(false, 'Random crap past here');

for cur_key  = mouse_cell_metadata_megastruct.keys();
    cur_output_path = sprintf('%s/%s/', ap.output_path, cur_key{1});
    MakeFilePath(cur_output_path);
    cur_data_path_list = mouse_cell_metadata_megastruct(cur_key{1});
    
    fprintf('Doing Stuff for Key %s \n', cur_key{1});
    
    for data_path_ind = 1:length(cur_data_path_list)
        cur_data_path =  cur_data_path_list{data_path_ind};
        cur_loaded = load(cur_data_path.path);
        cur_celldata_struct = cur_loaded.celldata;
        fprintf('\t Doing session %s \n', cur_celldata_struct.session);
        cur_firing_rate = SamMakeFiringRateList(cur_celldata_struct.vr_data.post, cur_celldata_struct.vr_data.spike_t);
        cur_firing_rate_map_struct = SamOneDRateMap(cur_celldata_struct.vr_data.posx, cur_firing_rate, cur_celldata_struct.vr_data.track_start, cur_celldata_struct.vr_data.track_end);
        
        if(1)
            close all;
            plot(cur_firing_rate_map_struct.x_values, cur_firing_rate_map_struct.purely_binned_rate, 'r', 'Linestyle', ':');
            hold on;
            plot(cur_firing_rate_map_struct.x_values, cur_firing_rate_map_struct.smoothed_firing_rate, 'k');
            cur_y_lim = get(gca, 'YLim');
            cur_y_lim(1) = 0;
            set(gca, 'YLim', cur_y_lim);
            output_file_path = sprintf('%s/Gain%f/SessionType(%s)_%s.png', cur_output_path, cur_celldata_struct.vr_data.gain_value, cur_celldata_struct.vr_data.session_type, cur_celldata_struct.session);
            MakeFilePath(output_file_path);
            saveas(1, output_file_path);
        end
    end
    
    
    
end
%
%
all_keys  = mouse_cell_metadata_megastruct.keys;
cur_key = all_keys(1);
cur_slice = mouse_cell_metadata_megastruct.values(cur_key);
cur_slice = cur_slice{1};

%error(true, 'Returning after packing megastruct');




