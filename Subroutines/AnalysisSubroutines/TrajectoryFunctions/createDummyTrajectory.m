function [traj] = createDummyTrajectory()

%traj.vel.x = [5 0 2];
%traj.vel.y = [0 1 2];

traj.vel.x = randn(5,1);
traj.vel.y = randn(5,1);



%Counter clockwise rotation by theta.
theta = .55;

[~, magv] = cart2pol(traj.vel.x, traj.vel.y);

vhat_x  = traj.vel.x./magv;
vhat_y = traj.vel.y./magv;



traj.hd_x = cos(theta)  * vhat_x  -sin(theta) * vhat_y;
traj.hd_y = sin(theta)  * vhat_x  +cos(theta) * vhat_y;



