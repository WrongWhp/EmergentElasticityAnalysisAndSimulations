for data_ind = 1:length(all_data_paths)
   traj = LoadTrajectoryYNorthXEast(all_data_paths{data_ind}.pos_path);
%   fprintf('%d, x range is %f, y range is %f \n', data_ind, nanmax(traj.posx) - nanmin(traj.posx),  nanmax(traj.posy) - nanmin(traj.posy)); 
    theta_list  = cart2pol(traj.hd_x, traj.hd_y);
%    theta_list  = cart2pol(traj.vel.x, traj.vel.y);
%    scatter(traj.vel.x, traj.vel.y, '.');
    
    rose(theta_list);
    wall_score(data_ind) = nanmean(cos(theta_list * 2).^2);
    fprintf('Wall Score is %f \n', nanmean(cos(theta_list * 2).^2));
%    pause;
    close all;
end
return;


if(0)
    %for i = maps_to_do
    %
    %    traj =   LoadTrajectoryYNorthXEast(all_data_paths{i}.pos_path);
    %   [vel_corr_list(i) vel] = headVelocityCorr(traj);
    %    theta(i) = calculateHDTiltBestProjection(traj);
    %end
end
for j = 1:4
    cur_cond = last_wall_nonex_conds{j};
    for i = maps_to_do
%        i
        traj =   LoadTrajectoryYNorthXEast(all_data_paths{i}.pos_path);
        [binned_indices average_offset] = AverageOffsetForCond(traj, cur_cond);
        x_array(:, :, i) = average_offset.x;
        y_array(:, :, i) = average_offset.y;
        
    end
    
    x_mean = nanmean(x_array, 3);
    y_mean = nanmean(y_array, 3);
    
    
    crop_inds = 2:4
    x_mean_crop = x_mean(crop_inds, crop_inds);
    y_mean_crop = y_mean(crop_inds, crop_inds);
    
    fprintf('For %s mean shift is %f %f \n', cur_cond.name, mean(x_mean_crop(:)), mean(y_mean_crop(:)));
    spitOutImageScFlipped(x_mean, sprintf('OutputShift/%s x.png', cur_cond.name));
    spitOutImageScFlipped(y_mean, sprintf('OutputShift/%s y.png', cur_cond.name));

        spitOutImageScFlipped(x_mean_crop, sprintf('OutputShift/%s xcrop.png', cur_cond.name));
    spitOutImageScFlipped(y_mean_crop, sprintf('OutputShift/%s ycrop.png', cur_cond.name));

%    pause;
end