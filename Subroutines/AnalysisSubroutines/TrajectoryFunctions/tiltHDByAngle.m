function [traj] = tiltHDByAngle(traj, theta)

hdx_tmp = traj.hd_x;
hdy_tmp = traj.hd_y;

traj.hd_y = sin(theta) * hdx_tmp + cos(theta) * hdy_tmp;
traj.hd_x = cos(theta) * hdx_tmp - sin(theta) * hdy_tmp;
