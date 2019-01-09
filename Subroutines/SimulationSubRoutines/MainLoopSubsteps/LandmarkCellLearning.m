%Updates the state of each landmark cell based on the statistics of the
%previously-run learning epoch. This will then be used to calculate the
%forces on the attractor network. 

fprintf('Landmark Cell Learning \n ');
fprintf('Making accum arrays for landmark cells \n ');
for lm_ind = 1:length(landmark_cell_list)
    cur_landmark_cell = landmark_cell_list{lm_ind};%Unpack the landmark cell
    cur_landmark_cell.total_times_visited = sum(system.times_visited_array(:) .* cur_landmark_cell.mask(:));        
    cur_landmark_cell.learned_z = sum(system.z_accum_array(:) .* cur_landmark_cell.mask(:))/cur_landmark_cell.total_times_visited;

    for i_xy = 1:2
       %Learn the xy estimate
       cur_est_xy_accum_slice = reshape(system.est_xy_accum_array(:, :, i_xy), system.box_size);
       cur_landmark_cell.learned_xy(i_xy) =  sum(cur_est_xy_accum_slice(:) .* cur_landmark_cell.mask(:))/cur_landmark_cell.total_times_visited;
    end
    
    for rh_iV = 1:sysparams.rh_graining
        for rh_iU = 1:sysparams.rh_graining
            cur_rh_accum_subarray = system.rh_accum_array(:, :, rh_iV, rh_iU); %Count of that iU and iV for each possible mouse position
            cur_landmark_cell.rh_dist_array(rh_iV, rh_iU) = sum(cur_rh_accum_subarray(:) .*cur_landmark_cell.mask(:));
        end
    end

    
%    fprintf('Total times cell visited is %f, total accum is %f \n', cur_landmark_cell.total_times_visited, sum(sum(cur_landmark_cell.rh_dist_array)));
    [cur_landmark_cell.rh_V_forcing, cur_landmark_cell.rh_U_forcing] = ForceArrayFromRhDist(cur_landmark_cell.rh_dist_array);    
    
    landmark_cell_list{lm_ind}=   cur_landmark_cell;    %Repack the landmark cell into the list
        
end


fprintf('Finished Landmark Cell Learning \n ');
