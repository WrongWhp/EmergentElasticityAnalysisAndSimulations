function [times_turned] = timesTurned(traj)

[theta, ~] = cart2pol(traj.hd_x, traj.hd_y);

not_nan_theta = theta(isfinite(theta));

theta_diff = diff(not_nan_theta);


theta_diff = mod(theta_diff + pi, 2* pi) -pi;

%theta_diff(theta_diff>pi) = theta_diff(theta_diff>pi) - 2 * pi;
%theta_diff(theta_diff<pi) = theta_diff(theta_diff<pi) + 2 * pi;

%plot(not_nan_theta);
plot(theta_diff);


times_turned = 0;