function [all_data_paths] = TraverseFreeRoamingData(data_dir_path);
fprintf('At TraverseFreeRoamingData');
listings = dir(data_dir_path);

pos_file_names = {};
acceptable_spike_file_endings ={};
for tetrode = 1:9
    for cluster = 1:9
        acceptable_spike_file_endings{length(acceptable_spike_file_endings) + 1} = sprintf('_T%dC%d', tetrode, cluster);
  %      acceptable_spike_file_endings{length(acceptable_spike_file_endings) + 1} = sprintf('_t%dC%d', tetrode, cluster);
   %     acceptable_spike_file_endings{length(acceptable_spike_file_endings) + 1} = sprintf('_T%dc%d', tetrode, cluster);
    %    acceptable_spike_file_endings{length(acceptable_spike_file_endings) + 1} = sprintf('_t%dc%d', tetrode, cluster);
    end
end




acceptable_position_names = {'_pos', '_POS'};
listings
for pos_file_ind = 1:length(listings)
    cur_file = listings(pos_file_ind);
    ok_position_file = true;
    fprintf('Trying listing %s \n', cur_file.name);
    for j = 1:length(acceptable_position_names)
        cur_pos_ending = acceptable_position_names{j};
        if(length(findstr(cur_file.name, cur_pos_ending)) > 0) %Might replace with strfind at some point
            fprintf('Trying file %s \n', cur_file.name);
            
            
            [ok_traj has_hd] = OkTrajectory([data_dir_path cur_file.name]);
            if(ok_traj && has_hd)
                pos_file_names{length(pos_file_names) + 1} = cur_file.name;
                pos_file_endings{length(pos_file_names)} = cur_pos_ending;
            end
            
        end
    end
    
    
end



cur_spike_file_ind = 1;



all_data_paths = {}
for pos_file_ind = 1:length(pos_file_names)
    cur_pos_path = [data_dir_path  '/'  pos_file_names{pos_file_ind}];
    cur_pos_ending =   pos_file_endings{pos_file_ind};
    for tc_ending = acceptable_spike_file_endings
        proposed_spike_path = strrep(cur_pos_path, cur_pos_ending, tc_ending{1});
%        possible_image_path = sprintf('%s_MapAndCorr.png',proposed_spike_path);

        [file_dir file_name file_extens] = fileparts(proposed_spike_path);
%        possible_image_path = [file_dir '/TrimmingData/' file_name file_extens '_MapAndCorr.png'];
        possible_image_path = [file_dir '/TrimmingData/' file_name  '.mat_MapAndCorr.png'];
%        possible_image_path = [file_dir '/TrimmingData/' file_name  'BinnedBaseRate.png'];

%        possible_image_path = [file_dir '/RateMapsSquareBox/' file_name  'BinnedBaseRate.png'];
%        possible_image_path = [file_dir '/RateMapsSquareBoxOnlyGoodCells/' file_name  'BinnedBaseRate.png'];
        
%        possible_image_path = [file_dir '/DidntSatisfy/' file_name file_extens '_MapAndCorr.png'];
        
        if(exist(proposed_spike_path))
            fprintf('Image path %s \n', possible_image_path);
            possible_image_path
            if(exist(possible_image_path) || true)%This is a crude way of marking out bad grid cells or good grid cells
                
                fprintf('Adding path %s \n', proposed_spike_path);
                cur_struct.pos_path = cur_pos_path;
                cur_struct.spike_path = proposed_spike_path;
                cur_struct.traj_ind = pos_file_ind;
                all_data_paths{length(all_data_paths) + 1} = cur_struct;
            end
        end
    end
    
end

fprintf('%d position files %d total data \n', length(pos_file_names), length(all_data_paths));

%strrep(cur_pos, '_pos', '_GOTIT')


