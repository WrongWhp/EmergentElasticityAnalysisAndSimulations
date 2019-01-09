%% Calculates spike positions

for data_ind = data_inds_to_do
    fprintf('Making spike positiions for data ind %d \n', data_ind);
    
    traj = all_data{data_ind}.traj;
    
    
    load(all_data_paths{data_ind}.spike_path);
    
    for path_cond_type_ind = path_cond_type_ind_list
        for path_cond_dir_ind = 1:4;
            opp_cond_dir_ind = oppositeDirectionInd(path_cond_dir_ind);
            
            cur_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
            satisfies_cond_inds = pathConditionSwitchboard(traj, cur_cond);
            cond_not_satisfied = setdiff(1:length(traj.posx), satisfies_cond_inds);
            
            posx = traj.posx;
            posy = traj.posy;
            
            cond_nanned_posx = posx;
            cond_nanned_posx(cond_not_satisfied) = nan;
            cond_nanned_posy = posy;
            cond_nanned_posy(cond_not_satisfied) = nan;
            
            
            [spkx, spky] = SamSpikePos(cellTS, cond_nanned_posx, cond_nanned_posy, traj.post);
            
            spike_pos_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = struct('x', spkx, 'y', spky);
            spike_com_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = ConditionalCOM(all_data{data_ind}.fcom_X, all_data{data_ind}.fcom_Y, spkx, spky);
            mouse_com_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = ConditionalCOM(all_data{data_ind}.fcom_X, all_data{data_ind}.fcom_Y, posx(satisfies_cond_inds), posy(satisfies_cond_inds));
            
            %            mouse_pos_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = struct('x', traj.posx(cond_, 'y', spky);
            
            
            
            %           cond_com = ConditionalCOM(all_data{data_ind}.fcom_X, all_data{data_ind}.fcom_Y, cur_cond_spike_positions.x, cur_cond_spike_positions.y);
        end
    end
    
end
