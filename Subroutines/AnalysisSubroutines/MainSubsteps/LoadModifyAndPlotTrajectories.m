%% Load And Modify All Trajectories.

for data_ind = 1:length(all_data_paths)
    
    fprintf('Making spike positiions for data ind %d \n', data_ind);
    traj = LoadTrajectoryYNorthXEast(all_data_paths{data_ind}.pos_path);
    
    if(1)
        theta = calculateHDTiltBestProjection(traj);
        traj.head_vel_angle = theta;
        traj = tiltHDByAngle(traj, -theta);
%        pixel_shift = 3 * 0;
        pixel_shift = 4;
%        traj = shiftPositionByHD(traj, pixel_shift);
        
        fprintf('Old angle was %f, New angle is %f \n',theta,  calculateHDTiltBestProjection(traj));
        traj = shiftPositionByHD(traj, pixel_shift);
        traj = NormalizeToCentimeters(traj, 100);
    end
    all_data{data_ind}.traj = traj;
    traj_wall_scores(data_ind) = TrajWallScore(traj);
    fprintf('Cur Traj Wall Score is %f \n', traj_wall_scores(data_ind));
    
    close all;
    plot(traj.posx, traj.posy);
    xlim(50 * [-1 1]);
    ylim(50 * [-1 1]);
    title(all_data_paths{data_ind}.pos_path, 'Interpreter', 'none');
%    plot_dir(traj.posx, traj.posy);
    traj_output_path = sprintf('%s/AllTrajectories/Traj%d.png', ap.output_path, data_ind);
    MakeFilePath(traj_output_path);
    saveas(1, traj_output_path);
    
    close all;
    
    traj_hist_output_path = sprintf('%s/AllTrajectories/TrajHist%d.png', ap.output_path, data_ind);
    

    subplot(3, 1, 1);
    hist(traj.posx, 300, 'r');
    hold on
    subplot(3,1,2);
    
    hist(traj.posy, 300, 'b');
    hold on;
    subplot(3,1,3);
    hist(traj.hd_diode_sep, 40);
    saveas(1, traj_hist_output_path);
    
    close all
    
    
    
    
    
    
    
    
end
