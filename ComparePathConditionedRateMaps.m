%% Clears stuff

close all
clear all%% Clears stuff


%% Initializes various things
addAllPaths
set(0,'DefaultAxesFontSize',16)
tic

global ap;
ap.n_bins  = 20;

ap.head_rotations_to_try = [1 3];
%ap.head_rotations_to_try = [2 4];


ap.past_cond_time_delay = 10;
ap.future_cond_time_offset = 10;
ap.min_cond_dist = 0;
ap.has_hit_wall_thresh = .1;
ap.actually_take_autocorr = 1; %If I flag this, the cross correlations between shifts actually become autocorrelations


rob_data_dirs = {};
%rob_data_dirs{length(rob_data_dirs)+1} = '../../../AllGridCellData/RobbSquish/WildtypeSquish/OpenField/';
%rob_data_dirs{length(rob_data_dirs)+1} = '../../../AllGridCellData/RobbSquish/WildtypeSquish/Squish/';
%rob_data_dirs{length(rob_data_dirs)+1} = '../../../AllGridCellData/RobbSquish/Trip8bSquish/OpenField/';
rob_data_dirs{length(rob_data_dirs)+1} = '../../../AllGridCellData/RobbSquish/Trip8bSquish/Squish/';

for pixel_shift = [4] %[0 2 4 6]
    for rob_data_ind = 1:length(rob_data_dirs);
        clear rate_map_mega_struct;
        
        
        
        rate_map_mega_struct.n_bins = ap.n_bins;
        
        %ap.has_hit_wall_thresh = .05;
        %    ap.data_dir_path = '../../../AllGridCellData/Data_OppHem/';
        %    ap.data_dir_path = '../../../AllGridCellData/TrimmedData/';
        %    ap.data_dir_path = '../../../AllGridCellData/TrimmedPlusOppHem/';
        %    ap.data_dir_path = '../../../AllGridCellData/RobbSquish/OpenField/';
        
        %    ap.data_dir_path = '../../../AllGridCellData/RobbSquish/WildtypeSquish/OpenField/';
        %    ap.data_dir_path = '../../../AllGridCellData/RobbSquish/WildtypeSquish/Squish/';
        
        %    ap.data_dir_path = '../../../AllGridCellData/RobbSquish/Trip8bSquish/OpenField/';
        
        % ap.data_dir_path = '../../../AllGridCellData/RobbSquish/Trip8bSquish/Squish/';
        ap.data_dir_path = rob_data_dirs{rob_data_ind}
        
        
        
        
        
        %    ap.data_dir_path = '../../AllData/LisasRatData/Frodo/';
        
        %ap.data_dir_path = '../../AllData/FakeData/FakeDataPathParr/';
        
        %    ap.data_dir_path = '../../AllData/Sargolini2006/all_data/';
        
        
        %ap.output_path = sprintf('%s/AnalysisOutputApr29GoodGridCellsHDFixed/', ap.data_dir_path);
        %    ap.output_path = sprintf('%s/AnalysisOutputJuly2017/StensPixelShift%.2d/', ap.data_dir_path, pixel_shift);
        ap.output_path = sprintf('%s/AnalysisOutputJuly2018/LoopPixelShift%.2d/', ap.data_dir_path, pixel_shift);
        
        %ap.output_path = sprintf('%s/AnalysisOutputApr27SmallWall/', ap.data_dir_path);
        
        
        all_data_paths = TraverseFreeRoamingData(ap.data_dir_path);
        LoadModifyAndPlotTrajectories
        
        
        
        ap.should_make_rate_maps =0;
        ap.should_load_rate_map = 1;
        ap.should_output_cond_images = 0;
        ap.should_output_base_images = 0;
        ap.thresh_streak_count = 2;
        
        %ap.rate_to_use = 'purely_binned_rate';
        %ap.rate_to_use = 'cm_smoothed_rate';
        %ap.rate_to_use = 'dummy_binned_rate';
%        ap.rate_to_use = 'stens_firing_rate';
        ap.rate_to_use = 'purely_binned_rate';
        
        ap.mouse_count_to_use = 'mouse_count';
        ap.spike_count_to_use = 'spike_count';
        
        
        
        MakeFilePath(ap.output_path);
        makeDirectionConditions
        makeShiftList
        
        
        maps_to_do = 1:length(all_data_paths);
        %maps_to_do = 200:250;
        %    maps_to_do = 1:7;
        %maps_to_do = 1:3;
        %    maps_to_do = 1:10;
        
        ap.path_cond_direction_list = 1:4; %North, south, east, west
        
        %        ap.path_cond_type_list = 1:11;
        %    ap.path_cond_type_list = 1;%Head Direction
        
        ap.path_cond_type_list = [1 4];%Last hit wall
        
        %    ap.path_cond_type_list = 1:11;
        %ap.path_cond_type_list = 1:11;
        %ap.path_cond_type_list = [1 2 10 11];
        %ap.path_cond_type_list = 10;
        %    ap.path_cond_type_list = [1]
        %ap.path_cond_type_list =[2 3  9];
        %ap.path_cond_type_list = 10;
        %ap.path_cond_type_list = 1:11;
        %ap.path_cond_type_list = [1 3];
        %ap.path_cond_type_list = 9;
        %ap.path_cond_type_list = 11;
        
        %input('Done!');
        rate_map_mega_struct_path = sprintf('%s/MegaStruct.mat', ap.output_path)
        
        %% Makes the rate map struct and saves it
        if(ap.should_make_rate_maps)
            %        CovAndSmoothingGallery
            %    ProcessCrossCorrInfo
            
            
            
            for data_ind = maps_to_do
                fprintf('Making rate map %d/%d \n', data_ind, length(maps_to_do));
                cur_data_path_struct = all_data_paths{data_ind};
                
                traj = LoadTrajectoryYNorthXEast(cur_data_path_struct.pos_path);
                if(1)
                    theta = calculateHDTiltBestProjection(traj);
                    traj.head_vel_angle = theta;
                    traj = tiltHDByAngle(traj, -theta);
                    traj = shiftPositionByHD(traj, pixel_shift);
                    ortho_pixel_shift = 4;
                    traj.posx = traj.posx + ortho_pixel_shift* traj.hd_y;
                    traj.posy = traj.posy - ortho_pixel_shift* traj.hd_x;
                    
                    
                    fprintf('Old angle was %f, New angle is %f \n',theta,  calculateHDTiltBestProjection(traj));
                end
                cellTS =  LoadFiringRate(cur_data_path_struct.spike_path);
                fr = SamMakeFiringRateList(traj.post, cellTS);
                %        fr = SamSortOfAdaptiveSmoothedFiringRateList(traj.post, cellTS);
                
                binned_indices = SortIndicesByBin(traj.posx, traj.posy);
                
                
                for path_cond_type_ind = ap.path_cond_type_list
                    
                    for path_cond_dir_ind = ap.path_cond_direction_list
                        %fprintf('Doing condition %d \n', direction_cond_ind);
                        cur_path_condition  = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
                        
                        satisfies_cond_inds = pathConditionSwitchboard(traj, cur_path_condition);
                        %NULL MODEL OF SCRAMBLING
                        %                satisfies_cond_inds = scramblePathConditions(satisfies_cond_inds, traj.N);
                        
                        % fprintf('For Cond: %s, Condition is met  %d/%d Times \n', cur_path_condition.name, length(satisfies_cond_inds), traj.N);
                        [kiah_rate_map cond_rate_map_struct satisfies_cond_inds] = ComputeRateMapFromIndsTrajCond(binned_indices, fr, traj, cur_path_condition);
                        
                        
                        rate_map_mega_struct.cond_maps{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = cond_rate_map_struct;
                        rate_map_mega_struct.cond_satisfied_inds{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = satisfies_cond_inds;
                        rate_map_mega_struct.paths{data_ind} = cur_data_path_struct;
                    end
                    
                    
                end
                [kiah_rate_map base_rate_map_struct] = ComputeRateMapFromBinnedIndices(binned_indices, fr, 1:length(traj.posy));
                %    [kiah_rate_map base_rate_map_struct] = KiahComputeRateMap(traj.posx, traj.posy, fr, 1:length(traj.posy));
                rate_map_mega_struct.base_maps{data_ind} = base_rate_map_struct;
                rate_map_mega_struct.data_paths{data_ind} = cur_data_path_struct;
                rate_map_mega_struct.trajectories{data_ind} = traj;
            end
            
            
            rate_cond_mega_struct.analysis_params = ap;
            rate_cond_mega_struct.path_condition_array =  path_condition_array;
            
            fprintf('Saving rate map...');
            MakeFilePath(rate_map_mega_struct_path);
            
            save(rate_map_mega_struct_path, 'rate_map_mega_struct');
            fprintf('Saved! \n');
            
            pause(5.0);
        end
        
        
        
        
        %center_of_box_inds = 3:18;
        x_center_of_box_inds = (5 * (rate_map_mega_struct.n_bins/20) ):(16 *(rate_map_mega_struct.n_bins/20));
        %    x_center_of_box_inds = [1 20];
        %    y_center_of_box_inds = x_center_of_box_inds;
        y_center_of_box_inds = (5 * (rate_map_mega_struct.n_bins/20) ):(16 *(rate_map_mega_struct.n_bins/20));
        %        y_center_of_box_inds = [1 20];
        
        
        %    center_of_box_inds = 5:16;
        
        %center_of_box_inds = 4:17;
        %center_of_box_inds = 6:15;
        %center_of_box_inds = 7:14;
        %center_of_box_inds = 4:7;
        
        
        
        
        
        
        
        %%  Loads the rate map struct and applies shifts
        if(ap.should_load_rate_map)
            
            load(rate_map_mega_struct_path)
            %    allAngularMomenta
            rate_map_mega_struct = nanOutLowStreakCounts(rate_map_mega_struct, ap.thresh_streak_count);
            %    rate_map_mega_struct = nanOutLowMouseCounts(rate_map_mega_struct, 50);
            
            rate_map_mega_struct = computeDataIndMaxFiringRates(rate_map_mega_struct, ap.rate_to_use);
            %Apply a few helper functions
            
            
            for data_ind = 1:length(rate_map_mega_struct.trajectories)
                fprintf('Loading rate map %d/%d \n', data_ind, length(maps_to_do));
                cur_max_rate = rate_map_mega_struct.max_rates{data_ind};%Max rate used for normalization of contourf
                
                base_rate_map_struct = rate_map_mega_struct.base_maps{data_ind};
                if(ap.should_output_base_images)
                    image_sc_param_struct = struct('title', 'Base Rate', 'range', [0 cur_max_rate]);
                    [spike_path spike_title spike_ending] = fileparts(all_data_paths{data_ind}.spike_path);
                    %            spitOutImageScFlipped(getfield(base_rate_map_struct, ap.rate_to_use), sprintf('%s/RateMaps/DataInd%d_zBinnedBaseRate.png', ap.output_path, data_ind), image_sc_param_struct);
                    spitOutImageScFlipped(getfield(base_rate_map_struct, ap.rate_to_use), sprintf('%s/RateMaps/%sBinnedBaseRate.png', ap.output_path, spike_title), image_sc_param_struct);
                    
                end
                
                
                for path_cond_type_ind = ap.path_cond_type_list
                    
                    for path_cond_dir_ind = ap.path_cond_direction_list
                        cur_path_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
                        
                        if(ap.actually_take_autocorr)
                            opposite_dir_ind = path_cond_dir_ind;
                        else
                            opposite_dir_ind = oppositeDirectionInd(path_cond_dir_ind);                            
                        end
                        
                        fprintf('Doing condition: %s  \n', cur_path_cond.name);
                        cond_rate_map_struct =rate_map_mega_struct.cond_maps{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
                        %                rate_map_mega_struct.cond_maps{data_ind}{direction_cond_ind}{path_or_head_cond}
                        opp_cond_rate_map_struct = rate_map_mega_struct.cond_maps{data_ind}{path_cond_type_ind}{opposite_dir_ind};
                        base_rates = getfield(base_rate_map_struct, ap.rate_to_use);
                        cond_rates  = getfield(cond_rate_map_struct, ap.rate_to_use);
                        opp_cond_rates = getfield(opp_cond_rate_map_struct, ap.rate_to_use);
                        
                        
                        if(ap.should_output_cond_images)
                            image_sc_param_struct = struct('title', cur_path_cond.name, 'range', [0 cur_max_rate]);
                            
                            spitOutImageScFlipped(getfield(cond_rate_map_struct, ap.rate_to_use), sprintf('%s/RateMaps/DataInd%d_zBinnedRateMapCond%dDir%d%s.png', ap.output_path, data_ind, path_cond_type_ind, path_cond_dir_ind, cur_path_cond.name), image_sc_param_struct);
                            %spitOutImageScFlipped(cond_rate_map_struct.mouse_count, sprintf('%s/MouseCounts/DataInd%d_zMouseCountCond%d%s.png', output_path, data_ind, direction_cond_ind, path_or_head_string));
                            %spitOutImageScFlipped(cond_rate_map_struct.streak_count, sprintf('%s/StreakCounts/DataInd%d_zStreakCountCond%d%s.png', output_path, data_ind, direction_cond_ind, path_or_head_string));
                        end
                        
                        
                        for shift_ind = 1:length(shifts_to_do)
                            
                            
                            
                            cur_shift_struct= shifts_to_do{shift_ind};
                            
                            %%Does the comparasion using a simple dot product
                            
                            iX_shift = cur_shift_struct.iX;
                            iY_shift = cur_shift_struct.iY;
                            shift_name = cur_shift_struct.name;
                            
                            
                            cropped_base_rates = base_rates(y_center_of_box_inds, x_center_of_box_inds);
                            cropped_cond_rates = cond_rates(y_center_of_box_inds, x_center_of_box_inds);
                            cropped_opp_cond_rates = opp_cond_rates(y_center_of_box_inds, x_center_of_box_inds);
                            
                            
                            %The first index(nor is shifted by iY, the second
                            %index is shifted by iX. We set things up such that
                            %all out of bounds indices give a value of nan.
                            
                            
                            
                            shifted_y_inds = y_center_of_box_inds+ iY_shift;
                            shifted_x_inds = x_center_of_box_inds + iX_shift;
                            shifted_y_out_of_bounds = find(~IsBetween(shifted_y_inds, 1,  ap.n_bins));
                            shifted_x_out_of_bounds = find(~IsBetween(shifted_x_inds, 1,  ap.n_bins));
                            
                            trimmed_shifted_y_inds = shifted_y_inds;
                            trimmed_shifted_y_inds(shifted_y_out_of_bounds) = 1;
                            
                            trimmed_shifted_x_inds = shifted_x_inds;
                            trimmed_shifted_x_inds(shifted_x_out_of_bounds) = 1;
                            
                            shifted_base_rates = base_rates(trimmed_shifted_y_inds, trimmed_shifted_x_inds);
                            shifted_cond_rates = cond_rates(trimmed_shifted_y_inds, trimmed_shifted_x_inds);
                            
                            
                            shifted_base_rates(shifted_y_out_of_bounds, :) = nan;
                            shifted_base_rates(:, shifted_x_out_of_bounds) = nan;
                            
                            shifted_cond_rates(shifted_y_out_of_bounds, :) = nan;
                            shifted_cond_rates(:, shifted_x_out_of_bounds) = nan;
                            
                            
                            %A bunch of inner products we might want to use.
                            cur_cond_shiftedbase_coeff = CompareRates(cropped_cond_rates, shifted_base_rates);
                            cur_base_shiftedbase_coeff = CompareRates(cropped_base_rates, shifted_base_rates);
                            cur_shiftedcond_base_coeff = CompareRates(shifted_cond_rates, cropped_base_rates);
                            cur_cond_base_coeff = CompareRates(cropped_cond_rates, cropped_base_rates);
                            
                            [cur_shiftedcond_opp_coeff, cur_overlap] = CompareRates(shifted_cond_rates, cropped_opp_cond_rates);
                            
                            cond_shiftedbase_cross_corr{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind)= cur_cond_shiftedbase_coeff;
                            base_shiftedbase_cross_corr{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind) = cur_base_shiftedbase_coeff;
                            %We see whether shifting the WINDOW of the CONDITIONAL map improves things.
                            %When the window-shift is the same way as the the way the conditional map is shifted, the inner product becomes better.
                            %                    corr_array_to_scatter{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind) = cur_shiftedcond_base_coeff - cur_base_shiftedbase_coeff;
                            
                            base_shiftedcond_cross_corr{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind) = cur_shiftedcond_base_coeff;
                            
                            opp_shiftedcond_cross_corr{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind) = cur_shiftedcond_opp_coeff;
                            opp_shiftedcond_overlap{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind) = cur_overlap;
                            
                            
                            cur_tracker_struct.path_cond = cur_path_cond;
                            cur_tracker_struct.shift = cur_shift_struct;
                            cond_and_shift_tracker_structs{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}{data_ind} = cur_tracker_struct;
                            
                            
                            cur_shift_inds = croppedShiftIndices(y_center_of_box_inds, x_center_of_box_inds, cur_shift_struct);
                            zero_shift_inds = croppedShiftIndices(y_center_of_box_inds, x_center_of_box_inds, zero_shift_struct);
                            
                            
                            if(0)
                                %% Trying to do the more statistically sophisiticated thing here with the poisson likelihood
                                
                                [opp_shiftedcond_log_likelihood opp_shiftedcond_coverage] = RateMapCompLogLikelyHood(cond_rate_map_struct, opp_cond_rate_map_struct, cur_shift_inds, zero_shift_inds);
                                fancy_shiftedcond_log_likelihood{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind) = opp_shiftedcond_log_likelihood;
                                coverage_array{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind) = opp_shiftedcond_coverage;
                                
                            else
                                coverage_array{path_cond_type_ind}{path_cond_dir_ind}{shift_ind}(data_ind) = true;%Just so the program doesn't crash
                                
                            end
                            
                            
                        end
                    end
                end
                
                fprintf('Finished rate map %d/%d \n', data_ind, length(maps_to_do));
            end
            
        end
        
        %computeIndexCorrelations
        
        %corr_array_to_scatter = base_shiftedcond_cross_corr;
        %ProcessCrossCorrInfo
        
        overlap_array_to_use = opp_shiftedcond_overlap;
        corr_array_to_scatter = opp_shiftedcond_cross_corr;
        
        %corr_array_to_scatter = fancy_shiftedcond_log_likelihood;
        ScatterCompareOppositeShifts
        makePathCondCrossCorrelelogram
        CovAndSmoothingGallery
        
    end
    
    toc
    
    
end