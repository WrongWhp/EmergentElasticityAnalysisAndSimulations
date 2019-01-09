
%% Calculates moments. BIt of a misnomer, does a bunch of other stuff.
max_x_diff = 0;
max_y_diff = 0;

for path_cond_type_ind = path_cond_type_ind_list
    
    fprintf('************** \n');
    for path_cond_dir_ind = 1:4;
        cur_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
        for data_ind = data_inds_to_do
            cur_spk_com_struct = spike_com_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            
            [spk_com{path_cond_dir_ind}.x(data_ind), spk_com{path_cond_dir_ind}.y(data_ind), spk_count{path_cond_dir_ind}(data_ind)] = MomentFromCOM(cur_spk_com_struct);
            
            cur_mouse_com_struct = mouse_com_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            [mouse_com{path_cond_dir_ind}.x(data_ind), mouse_com{path_cond_dir_ind}.y(data_ind), mouse_count{path_cond_dir_ind}(data_ind)] = MomentFromCOM(cur_mouse_com_struct);
            
            
            [whol_com{path_cond_dir_ind}.x(data_ind), whol_com{path_cond_dir_ind}.y(data_ind), whol_com_count{path_cond_dir_ind}(data_ind)] = MomentFromSpikeAndMouseCOM(cur_spk_com_struct, cur_mouse_com_struct);
        end
    end
    
    
    
    for path_cond_dir_ind = [1 3]
        for var_dir = 1:2
            
            opp_cond_dir_ind = oppositeDirectionInd(path_cond_dir_ind);
            for reg_opp_cond = 1:2
                
                fprintf('Doings var_dir %d reg_opp_cond %d \n', var_dir, reg_opp_cond);
                x_y = {'x', 'y'};
                x_or_y = x_y{var_dir};
                both_dir_conds = [path_cond_dir_ind opp_cond_dir_ind]
                dir_ind = both_dir_conds(reg_opp_cond);
                
                v1_spk{reg_opp_cond}{var_dir} = getfield(spk_com{dir_ind}, x_or_y);
                c1_spk{reg_opp_cond}{var_dir} = spk_count{dir_ind};
                
                v1_mouse{reg_opp_cond}{var_dir} = getfield(mouse_com{dir_ind}, x_or_y);
                c1_mouse{reg_opp_cond}{var_dir} = mouse_count{dir_ind};
                
                
                v1_whol{reg_opp_cond}{var_dir} = getfield(whol_com{dir_ind}, x_or_y)./whol_com_count{dir_ind};
                
            end
            
            v1 = v1_whol{1}{var_dir};
            v2 = v1_whol{2}{var_dir};
            
            
            v1_v2_diff{path_cond_type_ind}{path_cond_dir_ind}{var_dir} = v1 - v2;
            
            close all
            
            
            not_nan = isfinite(v1 + v2);
            ScatterWithSpine(v1, v2, and(abs(v1)>0, 0));            
            cur_binom_p_value = BinomialPValue(sum(isfinite(v1 + v2)), nansum(v1>v2));
            cur_signflip_p_value = signFlipPValue(v1-v2);
            xlim([-5 5]);
            ylim([-5 5]);
            
            cur_direction_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
            first_title_line = sprintf('%s, %s \n', cur_direction_cond.name, x_or_y);
            sec_title_line = sprintf('%d/%d, BinomP=%.5f \n', nansum(v1 > v2), sum(isfinite(v1 + v2)), cur_binom_p_value);
            third_title_line = sprintf('Diff is %.3f, signflip p = %.5f \n',   nanmean(v1 - v2), cur_signflip_p_value);
            
            
            title_to_use = [first_title_line sec_title_line third_title_line];
            title(title_to_use);
            
            %            title(sprintf('%s, %s shift, mean %f', path_condition_array{path_cond_type_ind}{path_cond_dir_ind}.name, x_or_y, nanmean(v1 - v2)));
            xlabel(path_condition_array{path_cond_type_ind}{path_cond_dir_ind}.name);
            ylabel(path_condition_array{path_cond_type_ind}{opp_cond_dir_ind}.name);
            
            folder_name = CorrFolderNamer(cur_direction_cond, x_or_y);
            cross_corr_file_title_with_spaces = sprintf('%s/OutputScatter/%s/%s(%s).png', ap.output_path,folder_name, cur_direction_cond.name, x_or_y);
            %                cross_corr_file_title_with_spaces = sprintf('%s/CondCrossCorr/%s/Path%dCond%d%s_%sShift.png','OutputScatter', path_cond_type_ind, folder_name, path_cond_dir_ind, cur_direction_cond.name, x_or_y);
            cross_corr_file_title = strrep(cross_corr_file_title_with_spaces, ' ', '_');
            %modifiedStr = strrep(origStr, oldSubstr, newSubstr)
            MakeFilePath(cross_corr_file_title);
            saveas(1, cross_corr_file_title);
            saveas(1, strrep(cross_corr_file_title, '.png', '.fig'));
    
            
            
            if(0)
                close all
                scatter(traj_wall_scores, v1-v2);
                first_title_line = sprintf('%s, %s vs. Wall \n', cur_direction_cond.name, x_or_y);
                [shift_to_wall_corr, shift_to_wall_p] = CorrPValue(v1-v2, traj_wall_scores, 'Spearman');
                sec_title_line = sprintf('Corr Is %f with p %f \n', shift_to_wall_corr, shift_to_wall_p);
                title([first_title_line sec_title_line]);



                cross_corr_wallscore_file_title = sprintf('%s/OutputScatter/%s/%s(%s).png', ap.output_path,'PathCondVsWall', cur_direction_cond.name, x_or_y);
                MakeFilePath(cross_corr_wallscore_file_title);
                saveas(1, cross_corr_wallscore_file_title);
            
            end
            %            v1 = v1_spk{1}{var_dir}./c1_spk{1}{var_dir} - v1_mouse{1}{var_dir}./c1_mouse{1}{var_dir};
            %            v2 = v1_spk{2}{var_dir}./c1_spk{2}{var_dir} - v1_mouse{2}{var_dir}./c1_mouse{2}{var_dir};
            
        end
        
    end
end

