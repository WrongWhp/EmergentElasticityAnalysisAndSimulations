
%% Calculates moments
%limited_data_inds = 1:100;
limited_data_inds = data_inds_to_do;

%path_cond_type_ind_list = 4;
%path_cond_type_ind_list = 1:11;

for path_cond_type_ind = path_cond_type_ind_list
    
    fprintf('Gathering Data\n');
    for path_cond_dir_ind = 1:4;
        cur_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
        for data_ind = limited_data_inds
            cur_mouse_com = mouse_com_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            cur_spike_pos_struct = spike_pos_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            
            spk_pos_minus_mouse_COMS{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = ...
                SpikePositionMinusMouseCOM(cur_spike_pos_struct.x, cur_spike_pos_struct.y, cur_mouse_com);
        end
    end
    
    fprintf('Using Data\n');
    for path_cond_dir_ind = [1 3]
        
        
        opp_cond_dir_ind = oppositeDirectionInd(path_cond_dir_ind);
        for reg_opp_cond = 1:2
            hold on;
            my_colors = {'r', 'b'};
            color_to_use = my_colors{reg_opp_cond};
            reg_and_opp = [path_cond_dir_ind opp_cond_dir_ind];
            reg_or_opp_dir_ind = reg_and_opp(reg_opp_cond);
            
            cur_direction_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
            opp_direction_cond = path_condition_array{path_cond_type_ind}{opp_cond_dir_ind};
            
            for data_ind = limited_data_inds
                fprintf('Using Data for ind %d \n', data_ind);
                
                cur_spk_pos_minus_mouse_COMS =  spk_pos_minus_mouse_COMS{data_ind}{path_cond_type_ind}{reg_or_opp_dir_ind};
                    gathered_xs_for_cells{data_ind} = cell2mat(cur_spk_pos_minus_mouse_COMS.x);
                    gathered_ys_for_cells{data_ind} = cell2mat(cur_spk_pos_minus_mouse_COMS.y);
                    
                    
                cur_x_variance = {};
                cur_y_variance = {};
                for peak_ind =  1:length(cur_spk_pos_minus_mouse_COMS.x)
                    cur_x_variance{peak_ind} = var(cur_spk_pos_minus_mouse_COMS.x{peak_ind});
                    cur_y_variance{peak_ind} = var(cur_spk_pos_minus_mouse_COMS.y{peak_ind});                    
%                    scatter( cur_spk_pos_minus_mouse_COMS.x{peak_ind}, cur_spk_pos_minus_mouse_COMS.y{peak_ind}, [color_to_use '.']);
                end
                
                variance_for_cells.x{reg_opp_cond}{data_ind} = nanmean(cell2mat(cur_x_variance));
                variance_for_cells.y{reg_opp_cond}{data_ind} = nanmean(cell2mat(cur_y_variance));
                
            end
            all_gathered_spikes.x{reg_opp_cond} = cell2mat(gathered_xs_for_cells);
            all_gathered_spikes.y{reg_opp_cond} = cell2mat(gathered_ys_for_cells);
            
            
        end
        
        if(1)
            
        for x_y_ind = 1:2
            close all;
            x_and_y = {'x', 'y'};            
            x_or_y = x_and_y{x_y_ind};
            spikes_to_use = getfield(all_gathered_spikes, x_or_y);
            variance_to_use = getfield(variance_for_cells, x_or_y);
            mean_var_1 = nanmean(cell2mat(variance_to_use{1}));
            mean_var_2 = nanmean(cell2mat(variance_to_use{2}));
            
            mean_to_subtract = .5 *(nanmean(spikes_to_use{1}) + nanmean(spikes_to_use{2}));
            fprintf('X_Y ind is %d, Lengths are %d, %d \n', x_y_ind, length(spikes_to_use{1}), length(spikes_to_use{2}));
            h1= histogram(spikes_to_use{1}-mean_to_subtract, -15:.25:15, 'Normalization', 'probability');
            hold on;
            h2 = histogram(spikes_to_use{2}-mean_to_subtract, -15:.25:15, 'Normalization', 'probability');
            xlim(15 * [-1 1])
            title(sprintf('%s has %s center %f var %f\n %s has %s center %f var', cur_direction_cond.name, x_or_y, nanmean(spikes_to_use{1}), opp_direction_cond.name, x_or_y, nanmean(spikes_to_use{2})));
            title(sprintf('%s has %s center %f var %f CellWisevar %f\n %s has %s center %f var %f  CellWisevar %f', cur_direction_cond.name, x_or_y, nanmean(spikes_to_use{1}), nanvar(spikes_to_use{1}), mean_var_1, opp_direction_cond.name, x_or_y, nanmean(spikes_to_use{2}), nanvar(spikes_to_use{2}), mean_var_2));
             set(gca, 'FontSize', 20)            
            legend(cur_direction_cond.name, opp_direction_cond.name);
            folder_name = CorrFolderNamer(cur_direction_cond, x_or_y);
           cross_corr_file_title_with_spaces = sprintf('%s/OutputGathered/%s/%s%s.pdf', ap.output_path, folder_name, cur_direction_cond.name, x_or_y);
           cross_corr_file_title_underscores = strrep(cross_corr_file_title_with_spaces, ' ', '_');
           MakeFilePath(cross_corr_file_title_underscores);
           saveas(1, cross_corr_file_title_underscores);
           saveas(1, strrep(cross_corr_file_title_underscores, '.pdf', '.fig'));

  %          fprintf('Scattering Data ...\n');
  %      scatter(all_gathered_xs{1}, all_gathered_ys{1}, 'r.');
  %      scatter(all_gathered_xs{2}, all_gathered_ys{2}, 'b.');
  %      fprintf('Finished Scattering Data ...\n');
%  pause;
  close all;
        end
        
        else
        %            folder_name = CorrFolderNamer(cur_direction_cond, x_or_y);
        cross_corr_file_title_with_spaces = sprintf('%s/OutputGathered/%s/%s.fig', ap.output_path,   cur_direction_cond.type, cur_direction_cond.name);
        %                cross_corr_file_title_with_spaces = sprintf('%s/CondCrossCorr/%s/Path%dCond%d%s_%sShift.png','OutputScatter', path_cond_type_ind, folder_name, path_cond_dir_ind, cur_direction_cond.name, x_or_y);
        cross_corr_file_title = strrep(cross_corr_file_title_with_spaces, ' ', '_');
        %modifiedStr = strrep(origStr, oldSubstr, newSubstr)
        MakeFilePath(cross_corr_file_title);
        saveas(1, cross_corr_file_title);
        close all;
       end
        
        
    end
end

return;
