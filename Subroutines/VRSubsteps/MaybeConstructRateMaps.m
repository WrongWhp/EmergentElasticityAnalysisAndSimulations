
mouse_cell_ratemap_megastruct_path = sprintf('%s/ZRateMapMegaStruct.mat', ap.output_path);


if(exist(mouse_cell_ratemap_megastruct_path))
    tic
    fprintf('Loading the mouse_cell_ratemap_megastruct, no need to recreate it from scratch! \n');
    load(mouse_cell_ratemap_megastruct_path)
    toc
else
    tic
    mouse_cell_ratemap_megastruct = mouse_cell_metadata_megastruct;
    
    for cur_key  = mouse_cell_ratemap_megastruct.keys();
        cur_data_path_list = mouse_cell_ratemap_megastruct(cur_key{1});
        fprintf('Making ratemaps for Key %s \n', cur_key{1});
        cur_run_list = mouse_cell_ratemap_megastruct(cur_key{1});
        
        
        
        for i = 1:length(cur_run_list)
            cur_run_struct = cur_run_list{i};
            tmp =  load(cur_run_struct.path);
            cur_vr_data = tmp.celldata.vr_data;
            
            
            
            clear trial_lengths;
            clear traj_velocity_scores;
            %Discard the last trial incase it only has partial data
             cur_firing_rate_arrays = struct();
            
            
            for trial_num = 1:(max(cur_vr_data.trial) - 1) 
                cur_trial_inds = (cur_vr_data.trial == trial_num);
                cur_trial_posx = cur_vr_data.posx(cur_trial_inds);
                cur_trial_post = cur_vr_data.post(cur_trial_inds);
                
                max_t = max(cur_trial_post);
                min_t = min(cur_trial_post);
                cur_trial_spike_t = cur_vr_data.spike_t(and(cur_vr_data.spike_t>min_t, cur_vr_data.spike_t<max_t));
                
                cur_trial_fr =SamMakeFiringRateList(cur_trial_post, cur_trial_spike_t);
                
                cur_trial_firing_rate_map = SamOneDRateMap(cur_trial_posx, cur_trial_fr, cur_vr_data.track_start, cur_vr_data.track_end);
                cur_vr_data.firing_rates{trial_num} = cur_trial_firing_rate_map;
%                trial_lengths(trial_num) = max_t - min_t;
                trial_lengths(trial_num) = sum(IsBetween(cur_trial_posx, 100, 300)) * mean(diff(cur_trial_post));
                traj_velocity_scores(trial_num) = VRTrajVelocityScore(cur_trial_posx);
                
                
                
                cur_firing_rate_arrays.smoothed_firing_rate_array(trial_num, :) = cur_trial_firing_rate_map.smoothed_firing_rate;
                cur_firing_rate_arrays.smoothed_mouse_count_array(trial_num, :) = cur_trial_firing_rate_map.smoothed_mouse_count;
                cur_firing_rate_arrays.smoothed_spike_count_array(trial_num, :) = cur_trial_firing_rate_map.smoothed_spike_count;
                
            end
            
%            imagesc(cur_firing_rate_arrays.smoothed_mouse_count_array);
%            pause(.5);
            n_trials = length(trial_lengths);
            
            cur_run_struct.vr_firing_rate_arrays = cur_firing_rate_arrays;
            cur_run_struct.vr_firing_rate_lists = cur_vr_data.firing_rates;

            cur_run_struct.manipulation_trial = cur_vr_data.manipulation_trial(1:n_trials);
            cur_run_struct.trial_lengths = trial_lengths;            
            cur_run_struct.traj_velocity_scores = traj_velocity_scores;
            cur_run_struct.n_trials = length(cur_run_struct.vr_firing_rate_lists);
            
            cur_run_struct.n_bins = length(cur_run_struct.vr_firing_rate_lists{1}.mouse_count);
            cur_run_struct.mouse = tmp.celldata.mouse;
            cur_run_struct.cell = tmp.celldata.cell;
            
            cur_run_list{i} = cur_run_struct;
            mouse_cell_ratemap_megastruct(cur_key{1}) = cur_run_list;
        end        
        
    end
    
    fprintf('Finished making mouse_cell_ratemap_megastruct! \n');
    MakeFilePath(mouse_cell_ratemap_megastruct_path);
%    save(mouse_cell_ratemap_megastruct_path, 'mouse_cell_metadata_megastruct');    

    %save('-v7.3',filepath\filename,structname) found from internet
        
    save('-v7.3', mouse_cell_ratemap_megastruct_path, 'mouse_cell_ratemap_megastruct');    
    assert(true, 'Returning after packing megastruct');    
    
    toc
end