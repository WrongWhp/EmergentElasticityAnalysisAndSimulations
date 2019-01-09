function [hd_tilt_angle ] = calculateHDTiltBestProjection(traj)

[vtheta, vr] = cart2pol(traj.vel.x, traj.vel.y);
[hdtheta hdr] = cart2pol(traj.hd_x, traj.hd_y);

hdtheta;

relative_theta = hdtheta - vtheta;

relative_theta = mod(relative_theta, 2* pi);


vr;

[v_dot_hd_par, v_dot_hd_ortho] = pol2cart(relative_theta, vr);




[best_theta, mean_projection_amount] = cart2pol(nanmean(v_dot_hd_par), nanmean(v_dot_hd_ortho));


fprintf('We can explain %f of velocity by projecting onto the new head direction \n', mean_projection_amount/nanmean(vr));

hd_tilt_angle = best_theta; 



