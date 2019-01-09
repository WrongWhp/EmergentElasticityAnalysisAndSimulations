function [rate_map_mega_struct] = computeDataIndMaxFiringRates(rate_map_mega_struct, rate_field_to_use)
global ap


for data_ind = 1:length(rate_map_mega_struct.base_maps)
    cur_max = nanmax(rate_map_mega_struct.base_maps{data_ind}.purely_binned_rate(:));
    
    for path_cond_type_ind = ap.path_cond_type_list
        
        for path_cond_dir_ind = ap.path_cond_direction_list
            cur_cond_map =  rate_map_mega_struct.cond_maps{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            cur_max = nanmax(cur_max, nanmax(nanmax(getfield(cur_cond_map, rate_field_to_use))));
        end
    end
    
    rate_map_mega_struct.max_rates{data_ind} = cur_max;
    fprintf('Max rate %s for data ind %d is %.4f \n', rate_field_to_use, data_ind, cur_max);
%    cur_max
end

