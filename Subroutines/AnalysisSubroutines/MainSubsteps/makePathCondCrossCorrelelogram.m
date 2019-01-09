
if(ap.should_load_rate_map)
    fprintf('Starting to compare shifts! \n');
    for path_cond_type_ind = ap.path_cond_type_list
        for path_cond_dir_ind = ap.path_cond_direction_list
            cur_cross_corr_array = zeros(2 * shift_range + 1)
            for shift_ind = 1:length(shifts_to_do)
                shift_struct = cond_and_shift_tracker_structs{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}{data_ind}.shift;
                v = corr_array_to_scatter{path_cond_type_ind}{path_cond_dir_ind}{shift_ind};
%                cur_direction_cond = cond_and_shift_tracker_structs{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}{data_ind}.path_cond;
                cur_direction_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
                
                
                array_iX = shift_struct.iX + shift_range + 1;
                array_iY = shift_struct.iY + shift_range + 1;
                
%                cur_cross_corr_array(array_iY, array_iX) = nanmedian(v);
                cur_cross_corr_array(array_iY, array_iX) = nanmean(v);
                
            end
            
            %We might want to nan this out for graphical reasons
%            cur_cross_corr_array(shift_range +1, shift_range + 1) = nan;
            

%            center_range = shift_range + [0 1 2];
            peak_location = superResolutionXYCenter(cur_cross_corr_array);
%            y_center = superResolutionYCenter(cur_cross_corr_array(center_range, center_range));
%            x_center = superResolutionYCenter(cur_cross_corr_array(center_range, center_range)');
            
            title_to_use = sprintf('%s:Center is (%.2f, %.2f)', cur_direction_cond.name, peak_location.x,peak_location.y);
            
            output_file = sprintf('%s/CrossCorrSc%s/%s.png', ap.output_path, ap.rate_to_use, cur_direction_cond.name);
%            image_sc_param_struct = struct('title', title_to_use, 'range', [0 1]);
            image_sc_param_struct = struct('title', title_to_use, 'make_dots', centerOfArrayMask(cur_cross_corr_array));

            
            
            
            MakeFilePath(output_file);
            spitOutImageScFlipped(cur_cross_corr_array, output_file, image_sc_param_struct);
            close all;
        end
    end
end








shift_range
