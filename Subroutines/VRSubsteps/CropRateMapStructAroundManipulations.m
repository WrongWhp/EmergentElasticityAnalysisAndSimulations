
filtered_ratemap_list = {};

for cur_key  = mouse_cell_ratemap_megastruct.keys();
    fprintf('Doing key %s \n', cur_key{1});
    cur_output_path = sprintf('%s/%s/', ap.output_path, cur_key{1});
    cur_ratemap_struct_list = mouse_cell_ratemap_megastruct(cur_key{1});
    
    for run_number = 1:length(cur_ratemap_struct_list)
        cur_ratemap_struct = cur_ratemap_struct_list{run_number};

        should_use_ratemap_struct = true;

        if(isfield(rate_map_filter, 'session_type'))
           should_use_ratemap_struct =  should_use_ratemap_struct && strcmp(cur_ratemap_struct.session_type, rate_map_filter.session_type);
        end
                
        if(isfield(rate_map_filter, 'gain_value'))
           should_use_ratemap_struct =  should_use_ratemap_struct && cur_ratemap_struct.gain_value ==rate_map_filter.gain_value;
        end

        if(isfield(rate_map_filter, 'grid_score_bounds'))
           should_use_ratemap_struct =  should_use_ratemap_struct && IsBetween(cur_ratemap_struct.open_field_scores.grid_score, rate_map_filter.grid_score_bounds(1),  rate_map_filter.grid_score_bounds(2));
        end
        
        if(isfield(rate_map_filter, 'border_score_bounds'))
           should_use_ratemap_struct =  should_use_ratemap_struct && IsBetween(cur_ratemap_struct.open_field_scores.border_score, rate_map_filter.border_score_bounds(1), rate_map_filter.border_score_bounds(2));
        end
        
        
        if(isfield(rate_map_filter, 'min_trials'))
           should_use_ratemap_struct =  should_use_ratemap_struct && (cur_ratemap_struct.n_trials>=rate_map_filter.min_trials);
        end
                
        

        
        
        if(should_use_ratemap_struct)
            fprintf('Appending ratmap struct to list \n');
           filtered_ratemap_list{length(filtered_ratemap_list)+1} =  cur_ratemap_struct;
        end
%        should_use_ratemap_struct = strcmp(cur_ratemap_struct.session_type, rate_map_filter.session_type);
%        should_use_ratemap_struct = should_use_ratemap_struct && cur_ratemap_struct.gain_value == 1.5;
%        should_use_ratemap_struct = should_use_ratemap_struct && cur_ratemap_struct.open_field_scores.grid_score>.2;
%        should_use_ratemap_struct = should_use_ratemap_struct && cur_ratemap_struct.open_field_scores.border_score < .3;                
        
        
    end
    
end



filtered_mouse_labels = [];
for i_struct = 1:length(filtered_ratemap_list)
    cur_ratemap_struct = filtered_ratemap_list{i_struct};    
    if(i_struct == 1)
       filtered_mouse_labels(i_struct) = 1;
    else
        if(strcmp(cur_ratemap_struct.mouse, filtered_ratemap_list{i_struct-1}.mouse) >0)
            filtered_mouse_labels(i_struct) = filtered_mouse_labels(i_struct-1)
        else
            filtered_mouse_labels(i_struct) = filtered_mouse_labels(i_struct-1) +1;
        end
        
    end
        

end
    fprintf('%d Structs passed the filter \n', length(filtered_ratemap_list));

filtered_mouse_labels



