mouse_cell_metadata_megastruct_path = sprintf('%s/ZMetaDataMegaStruct.mat', ap.output_path);


if(exist(mouse_cell_metadata_megastruct_path) )
    fprintf('Loading the mouse_cell_metadata_megastruct, no need to recreate it from scratch! \n');
    load(mouse_cell_metadata_megastruct_path)
else
    
    fields_to_copy = {'session_type', 'gain_value', 'track_start', 'pattern_transition_positions', 'recording_length', 'tower_positions'};
    
    %Traverses the data
    data_dir_path = ap.data_dir_path
    listings = dir(data_dir_path);
    data_file_names = {};
    for file_ind = 1:length(listings)
        
        cur_file = listings(file_ind);
        if(length(strfind(cur_file.name, '.mat')) > 0)
            path_to_add = [data_dir_path cur_file.name];
            struct_to_add = struct('path', path_to_add);
            
            
            
            data_file_names{length(data_file_names) + 1} = struct_to_add;
            fprintf('Adding %s \n', path_to_add);
        end
    end
    fprintf('%d paths added', length(data_file_names));
    
    
    
    all_data_paths = data_file_names;
    
    
    
    MakeFilePath(mouse_cell_metadata_megastruct_path);
    
    
    
    mouse_cell_metadata_megastruct = containers.Map;
    
    fprintf('Packing megastruct..');
    mega_struct_size = 0;
    for data_path_ind =1:length(all_data_paths)
        fprintf('Loading struct %d \n', data_path_ind);
        cur_data_path = all_data_paths{data_path_ind};
        cur_loaded = load(cur_data_path.path);
        cur_celldata_struct = cur_loaded.celldata;
        cur_key = [cur_celldata_struct.mouse '_' cur_celldata_struct.cell];
        
        
        for field_ind = 1:length(fields_to_copy)
            field_name = fields_to_copy{field_ind};
            value_to_add = getfield(cur_celldata_struct.vr_data, field_name);
            cur_data_path = setfield(cur_data_path, field_name, value_to_add);
            %        field_name
            %        cur_data_path
        end
        
        cur_data_path.open_field_scores  = cur_celldata_struct.of_data;
        cur_data_path.mouse = cur_celldata_struct.mouse;
        cur_data_path.cell = cur_celldata_struct.mouse;
        
        %    track_ends(data_path_ind) = cur_celldata_struct.vr_data.track_end;
        %    track_starts(data_path_ind) = cur_celldata_struct.vr_data.track_start;
        
        if(~mouse_cell_metadata_megastruct.isKey(cur_key))
            mouse_cell_metadata_megastruct(cur_key) = {};
        end
        mega_struct_size = mega_struct_size+1;
        unpacked_obj = mouse_cell_metadata_megastruct(cur_key);
        unpacked_obj{length(unpacked_obj) + 1} = cur_data_path;
        mouse_cell_metadata_megastruct(cur_key) = unpacked_obj;
    end
    fprintf('Finished packing megastruct, %d Elements added \n', mega_struct_size);
        
    save(mouse_cell_metadata_megastruct_path, 'mouse_cell_metadata_megastruct');    
    assert(true, 'Returning after packing megastruct');    
end