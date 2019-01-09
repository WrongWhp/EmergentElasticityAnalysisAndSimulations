%Plots the learned state of a landmark Theta_i for all landmark cells.

fprintf(' AT OutputLandmarkCellZFields \n');
if(sysparams.verbose.output_landmark_fields)
    for landmark_cell_num =1:length(landmark_cell_list)
        cur_landmark_cell = landmark_cell_list{landmark_cell_num};
        
        
        cur_z = cur_landmark_cell.learned_z;
        cur_z_angle = imag(log(cur_landmark_cell.learned_z));
        %    rh_dist_image = RhDistImage(cur_landmark_cell.rh_dist_array);
        
        dummy_firing_rate = -1 * ones(system.box_size);
        dummy_firing_rate(cur_landmark_cell.mask) = 1;
        dummy_firing_rate_image = FiringRateImage(system, dummy_firing_rate, ones(system.box_size));
        
        clock_image = MakeClockAngle(cur_z, size(dummy_firing_rate_image, 1));
        
        
        cat_im = [dummy_firing_rate_image clock_image];
        
        
        imwriteWithPath(cat_im, sprintf('%s/LandmarkCells/ZForcing/Run%d/LandmarkCell%dLearnedZRun%d.png', sysparams.folder_path, run_num,  landmark_cell_num, run_num));
        imwriteWithPath(cat_im, sprintf('%s/LandmarkCells/ZForcing/GroupedZFiring/LandmarkCell%dLearnedZRun%d.png',sysparams.folder_path, landmark_cell_num, run_num));
        
        
        % fprintf('Centers are x=%f, y=%f, Learned_z is %1.4g +  %1.4g j \n', cur_landmark_cell.x_center, cur_landmark_cell.y_center, real(cur_landmark_cell.learned_z), imag(cur_landmark_cell.learned_z));
        
    end
end

forcing_to_display = system.z_forcing_array;
forcing_to_display(~system.in_bounds) = 0;
forcing_clock_image = FiringRateClockImage(system,  forcing_to_display,  abs(forcing_to_display));
imwriteWithPath(forcing_clock_image, sprintf('%s/LandmarkCells/MeanZForcing/MeanZForcingRun%d.png',sysparams.folder_path, run_num));
fprintf(' Finished OutputLandmarkCellZFields \n');

