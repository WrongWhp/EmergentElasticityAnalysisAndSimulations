function [hd_tilt_angle] = calculateHDTilt(traj)



vx_vx_corr = nanmean(traj.vel.x .* traj.vel.x);
vx_vy_corr = nanmean(traj.vel.x .* traj.vel.y);
vy_vx_corr = nanmean(traj.vel.y .* traj.vel.x);
vy_vy_corr = nanmean(traj.vel.y .* traj.vel.y);


vel_vel_matrix = [vy_vy_corr vx_vy_corr; vy_vx_corr vx_vx_corr]

hdx_vx_corr = nanmean(traj.hd_x .* traj.vel.x);
hdx_vy_corr = nanmean(traj.hd_x .* traj.vel.y);
hdy_vx_corr = nanmean(traj.hd_y .* traj.vel.x);
hdy_vy_corr = nanmean(traj.hd_y .* traj.vel.y);


cur_hd_vel_matrix = [hdy_vy_corr hdx_vy_corr; hdy_vx_corr hdx_vx_corr];
cur_hd_vel_matrix

sqrt_inv_v = vel_vel_matrix ^(-1/2);
hd_tilt_angle = EstimateRotationMatrix(sqrt_inv_v * cur_hd_vel_matrix * sqrt_inv_v);

