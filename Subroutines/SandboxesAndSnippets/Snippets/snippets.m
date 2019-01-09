    %If the head velocity correlation is backwards, we assume that the diodes
    %became switched somehow, and flip the head direction. We now try all
    %four rotations because some data sets have the diodes on the front and
    %back of the head.
    theta_list = (0:3) * (2 * pi) / 4;
    head_vel_corr_list = zeros(4, 1);
    
    for i = ap.head_rotations_to_try;
        cur_theta = theta_list(i);
        traj_struct_rotations{i} = traj_struct;
        traj_struct_rotations{i}.hd_y = sin(cur_theta) * traj_struct.hd_x + cos(cur_theta) * traj_struct.hd_y;
        traj_struct_rotations{i}.hd_x = cos(cur_theta) * traj_struct.hd_x - sin(cur_theta) * traj_struct.hd_y;
        [cur_corr vel] = headVelocityCorr(traj_struct_rotations{i});
        
        
        head_vel_corr_list(i)  = cur_corr;
%        fprintf('Ind %d has corr %f \n', i, head_vel_corr_list(i));
        
    end
    
    head_vel_corr_list;
    [best_corr, best_corr_ind] = max(head_vel_corr_list);
    
    