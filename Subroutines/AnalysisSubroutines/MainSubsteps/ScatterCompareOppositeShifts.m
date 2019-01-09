
%global ap
close all
for data_ind = maps_to_do
    cur_traj = rate_map_mega_struct.trajectories{data_ind};
    has_hd(data_ind) = cur_traj.has_hd;
    %   one_vs_three(data_ind) = cur_traj.rot_ind_one_vs_three;
    %   two_vs_four(data_ind) = cur_traj.rot_ind_two_vs_four;
    
    hdx_vx_corr(data_ind) = nanmean(cur_traj.hd_x .* cur_traj.vel.x);
    hdx_vy_corr(data_ind) = nanmean(cur_traj.hd_x .* cur_traj.vel.y);
    hdy_vx_corr(data_ind) = nanmean(cur_traj.hd_y .* cur_traj.vel.x);
    hdy_vy_corr(data_ind) = nanmean(cur_traj.hd_y .* cur_traj.vel.y);
    
    cur_matrix = [hdx_vx_corr(data_ind) hdy_vx_corr(data_ind); hdx_vy_corr(data_ind) hdy_vy_corr(data_ind)];
    head_vel_angles(data_ind) = EstimateRotationMatrix(cur_matrix);
    
    traj_ids(data_ind) = all_data_paths{data_ind}.traj_ind;
end


if(ap.should_load_rate_map)
    fprintf('Starting to compare shifts! \n');
    for path_cond_type_ind = ap.path_cond_type_list
        for path_cond_dir_ind = ap.path_cond_direction_list
            for shift_pair_ind = 1:length(opp_shift_pairs)
                shift_1_ind = opp_shift_pairs{shift_pair_ind}{1};
                shift_2_ind = opp_shift_pairs{shift_pair_ind}{2};
                shift1_struct = cond_and_shift_tracker_structs{path_cond_type_ind}{path_cond_dir_ind}{shift_1_ind}{data_ind}.shift;
                shift2_struct = cond_and_shift_tracker_structs{path_cond_type_ind}{path_cond_dir_ind}{shift_2_ind}{data_ind}.shift;
                cur_direction_cond = cond_and_shift_tracker_structs{path_cond_type_ind}{path_cond_dir_ind}{shift_2_ind}{data_ind}.path_cond;
                
                
                cur_direction_cond_name = cur_direction_cond.name;
                
                fprintf('Direction is %d, path_cond_type_ind is %d \n', path_cond_dir_ind, path_cond_type_ind);
                
                %Correlation when you shift one way or the other
                overlap_1 = overlap_array_to_use{path_cond_type_ind}{path_cond_dir_ind}{shift_1_ind};
                overlap_2 = overlap_array_to_use{path_cond_type_ind}{path_cond_dir_ind}{shift_2_ind};
                
                mean_overlap = .5 * (overlap_1  +overlap_2);
                
                v1 = corr_array_to_scatter{path_cond_type_ind}{path_cond_dir_ind}{shift_1_ind};
                v2 = corr_array_to_scatter{path_cond_type_ind}{path_cond_dir_ind}{shift_2_ind};
                
                v1_v2_diff{path_cond_type_ind}{path_cond_dir_ind}{shift_pair_ind} = v1 - v2;
                
                coverage_1 = coverage_array{path_cond_type_ind}{path_cond_dir_ind}{shift_1_ind};
                coverage_2 = coverage_array{path_cond_type_ind}{path_cond_dir_ind}{shift_2_ind};
                %                ScatterWithSpine(v1, v2, ~has_hd);
%                ScatterWithSpine(v1, v2, head_vel_angles < median(head_vel_angles));


                ScatterWithSpine(v1, v2, and(mean_overlap < median(mean_overlap), false));
                
                %               ScatterWithSpine(v1, v2, .5 * (coverage_1 + coverage_2) < 80);
                xlabel(shift1_struct.name);
                ylabel(shift2_struct.name);
                
                cur_binom_p_value = BinomialPValue(sum(isfinite(v1 + v2)), nansum(v1>v2));
                cur_signflip_p_value = signFlipPValue(v1-v2);
                
                %                ang_momentum_corr = corr(MakeHorizontal(v1-v2)', MakeHorizontal(angular_momentum_list)', 'type', 'Pearson');
                angular_momentum_list = nan*v1;
                [ang_momentum_corr ang_mom_corr_p_val] = CorrPValue(v1-v2, angular_momentum_list, 'Pearson');
                
                
                poly_fit = polyfit(ap.sm * [-1 0 1], [nanmean(v2) 0 nanmean(v1)], 2);
                estimated_peak = -(1/2)  * poly_fit(2)/poly_fit(1);%Linear Component/Quadratic Component
                
                
                first_title_line = sprintf('%s, %d/%d, BinomP=%.7f \n', cur_direction_cond_name, nansum(v1 > v2), sum(isfinite(v1 + v2)), cur_binom_p_value);
                sec_title_line = sprintf('Diff is %.7f, signflip p = %.7f \n',   nanmean(v1 - v2), cur_signflip_p_value);
                %                third_title_line = sprintf('SignflipP(v1) = %.7f, SignFlipP(v2) = %.7f, Estimated Peak is %.7f \n', signFlipPValue(v1), signFlipPValue(v2), estimated_peak);
                third_title_line = sprintf('Estimated Peak(Parabolic Fit) is %.7f \n', estimated_peak);
                
                
                fourth_title_line = sprintf('Corr With Angmom is %.4f with ScrambleP %.4f \n ', ang_momentum_corr, ang_mom_corr_p_val);
                if(0)
                    
                    [ellipticity_corr ellipticity_corr_p_val] = CorrPValue(v1-v2, rate_map_mega_struct.sam_ellipticities, 'Pearson');
                    
                    [min_theta_corr min_theta_corr_p_val] = CorrPValue(v1-v2, min_thetas, 'Pearson');
                    
                    fifth_title_line = sprintf('Corr With Ellipt is %.4f with ScrambleP %.4f \n ', ellipticity_corr, ellipticity_corr_p_val);
                    sixth_title_line = sprintf('Corr With MinTheta is %.4f with ScrambleP %.4f ', min_theta_corr, min_theta_corr_p_val);
                    title([first_title_line sec_title_line third_title_line fourth_title_line fifth_title_line sixth_title_line]);
                elseif(0)
                    [coverage_diff_corr, coverage_diff_p_val] = CorrPValue(v1-v2, coverage_1-coverage_2, 'Pearson');
                    
                    [mean_coverage_corr, mean_coverage_corr_p_val] = CorrPValue(v1-v2, .5 * (coverage_1 + coverage_2), 'Pearson');
                    
                    fifth_title_line = sprintf('Corr With Coverage Diff is %.4f with ScrambleP %.4f \n ', coverage_diff_corr, coverage_diff_p_val);
                    sixth_title_line = sprintf('Corr With Mean Coverage is %.4f with ScrambleP %.4f \n ', mean_coverage_corr, mean_coverage_corr_p_val);
                    
                    [head_vel_angle_corr, head_vel_angle_corr_p_value] = CorrPValue(v1-v2, head_vel_angles, 'Pearson');
                    [head_vel_angle_sign_corr, head_vel_angle_sign_corr_p_value] = CorrPValue(sign(v1-v2), sign(head_vel_angles), 'Pearson');
                    
                    seventh_title_line = sprintf('Corr With Head Vel Rotation is %.4f with ScrambleP %.4f \n ', head_vel_angle_corr, head_vel_angle_corr_p_value);
                    eigth_title_line = sprintf('SignCorr With Head Vel Rotation is %.4f with ScrambleP %.4f \n ', head_vel_angle_sign_corr, head_vel_angle_sign_corr_p_value);
                    
                    title([first_title_line sec_title_line third_title_line fourth_title_line  fifth_title_line sixth_title_line seventh_title_line]);
                    
                else
                    [inter_ind_corr_coeff inter_ind_p_val] = InterIndCorrTest(v1-v2, traj_ids)
                    [inter_ind_sign_corr_coeff inter_ind_sign_p_val] = InterIndCorrTest(sign(v1-v2), traj_ids)

                    fifth_title_line =  sprintf('InterIndCorr is %.4f with ScrambleP %.4f \n', inter_ind_corr_coeff, inter_ind_p_val);
                    sixth_title_line =  sprintf('InterIndSignCorr is %.4f with ScrambleP %.4f \n', inter_ind_sign_corr_coeff, inter_ind_sign_p_val);

                    title([first_title_line sec_title_line third_title_line fourth_title_line  fifth_title_line sixth_title_line]);
                    
                end
                
                folder_name = CorrFolderNamer(cur_direction_cond, shift1_struct);
                cross_corr_file_title_with_spaces = sprintf('%s/CondCrossCorr/Corr%s/%s/Path%dCond%d%s_%s_vs_%s.png',ap.output_path, ap.rate_to_use, folder_name, path_cond_type_ind, path_cond_dir_ind, cur_direction_cond_name, shift2_struct.name, shift1_struct.name);
                cross_corr_file_title = strrep(cross_corr_file_title_with_spaces, ' ', '_');
                %modifiedStr = strrep(origStr, oldSubstr, newSubstr)
                MakeFilePath(cross_corr_file_title);
                saveas(1, cross_corr_file_title);
                saveas(1, strrep(cross_corr_file_title, '.png', '.fig'));
                
                %                pause;
                
                
                close all;
                
                
                if(0)
                    ScatterWithBounds(head_vel_angles * 180/pi, v1-v2);
                    xlabel('Head Vel Angles');
                    ylabel(sprintf('%s - %s ', shift1_struct.name, shift2_struct.name));
                    folder_name = CorrFolderNamer(cur_direction_cond, shift1_struct);
                    other_corr_file_title_with_spaces = sprintf('%s/CondCrossCorr/%s/Path%dCond%d%s_%s_vs_%sOtherCorr.png',ap.output_path, folder_name, path_cond_type_ind, path_cond_dir_ind, cur_direction_cond_name, shift2_struct.name, shift1_struct.name);
                    other_corr_file_title = strrep(other_corr_file_title_with_spaces, ' ', '_');
                    saveas(1, other_corr_file_title);
                    close all;
                end
                
                
                
            end
        end
        
    end
    
    
    for path_cond_type_ind = ap.path_cond_type_list
    
    close all
    
    a1 = v1_v2_diff{path_cond_type_ind}{1}{1};
    a2 = v1_v2_diff{path_cond_type_ind}{3}{2};
    
    [a1_a2_corr, a1_a2_corr_p_values] = CorrPValue(a1, a2, 'spearman');
    scatter(a1, a2);
    title(sprintf('%s (x) vs. \n %s (y) \n Corr is %f With PValue of %f', path_condition_array{path_cond_type_ind}{1}.name, path_condition_array{path_cond_type_ind}{3}.name , a1_a2_corr, a1_a2_corr_p_values));
    output_path = sprintf('%s/Shiftcorrelation/%s.png', ap.output_path, path_condition_array{path_cond_type_ind}{1}.name)
    MakeFilePath(output_path);
    saveas(1, output_path);
end


    
    
end

