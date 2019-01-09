for data_ind = maps_to_do
    fprintf('Computing index correlations for rate map %d \n', data_ind);
    for path_cond_dir_ind = ap.path_cond_direction_list
        
        for path_cond_type_ind_1 = ap.path_cond_type_list
            for path_cond_type_ind_2 = ap.path_cond_type_list
                %fprintf('Doing another one \n');
                
                satisfies_cond_inds_1 =  rate_map_mega_struct.cond_satisfied_inds{data_ind}{path_cond_type_ind_1}{path_cond_dir_ind};
                satisfies_cond_inds_2 =  rate_map_mega_struct.cond_satisfied_inds{data_ind}{path_cond_type_ind_2}{path_cond_dir_ind};
                cur_correlation = indexCorrelation(satisfies_cond_inds_1, satisfies_cond_inds_2, rate_map_mega_struct.trajectories{data_ind}.N);
                cond_type_corr_array(path_cond_type_ind_1, path_cond_type_ind_2, path_cond_dir_ind, data_ind) = cur_correlation;
                
            end
        end
    end
end
                
