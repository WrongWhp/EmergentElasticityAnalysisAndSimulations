%Plots the hebbian weight in the attractor basis W(phi_u, phi_v) 

for landmark_cell_num =1:length(landmark_cell_list)
    cur_landmark_cell = landmark_cell_list{landmark_cell_num};
    
    
    rh_dist_image = RhDistImage(cur_landmark_cell.rh_dist_array);

    dummy_firing_rate = -1 * ones(system.box_size) + 2* cur_landmark_cell.mask;
    dummy_firing_rate_image = FiringRateImage(system, dummy_firing_rate, ones(system.box_size));
    
    resize_amount = size(dummy_firing_rate_image, 1)/size(rh_dist_image, 1);    
    resized_dist_image = imresize(rh_dist_image, resize_amount, 'nearest');
    
    cat_im = [dummy_firing_rate_image resized_dist_image];
    
    
%    imwriteWithPath(cat_im, sprintf('%s/LandmarkCells/RhDists/Run%d/LandmarkCell%dRhDistRun%d.png', sysparams.folder_path, run_num,  landmark_cell_num, run_num));
    imwriteWithPath(cat_im, sprintf('%s/LandmarkCells/RhDists/Grouped/LandmarkCell%dRhDistRun%d.png',sysparams.folder_path, landmark_cell_num, run_num));
    
    
    % fprintf('Centers are x=%f, y=%f, Learned_z is %1.4g +  %1.4g j \n', cur_landmark_cell.x_center, cur_landmark_cell.y_center, real(cur_landmark_cell.learned_z), imag(cur_landmark_cell.learned_z));
    
    landmark_cell_neg_entropy_array(run_num, landmark_cell_num) = CalculateEntFromRandom(cur_landmark_cell.rh_dist_array);
end


