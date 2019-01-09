function [rate_map_mega_struct] = nanOutLowStreakCounts(rate_map_mega_struct, streak_count_thresh)
global ap

for data_ind = 1:length(rate_map_mega_struct.base_maps)
    
    
    base_rate_map_struct = rate_map_mega_struct.base_maps{data_ind};
    base_rate_map_struct.purely_binned_rate(base_rate_map_struct.streak_count<streak_count_thresh) = nan;
    rate_map_mega_struct.base_maps{data_ind} = base_rate_map_struct;
    
    for path_cond_type_ind = ap.path_cond_type_list
        
        for path_cond_dir_ind = ap.path_cond_direction_list
            
            cur_cond_map_struct =  rate_map_mega_struct.cond_maps{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            %Unpacks struct
            cur_cond_map_struct.purely_binned_rate(cur_cond_map_struct.streak_count<streak_count_thresh) = nan;
            rate_map_mega_struct.cond_maps{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = cur_cond_map_struct;
            
        end
    end
    
end