function [vel] = calculateVelocity(traj)


%Will just trim the Nans for now. not exactly kosher, but there aren't too
%many of them.

not_nan_inds = isfinite(traj.posx + traj.posy);


filter_width = 75;
my_filter = fspecial('gaussian', [(2 * filter_width + 1) 1], 25);

my_filter = my_filter .* ((-filter_width):filter_width)';

not_nan_x = traj.posx(not_nan_inds);
not_nan_y = traj.posy(not_nan_inds);

not_nan_vx = imfilter(not_nan_x, my_filter);
not_nan_vy = imfilter(not_nan_y, my_filter);

vx  = nan(size(traj.hd_x));
vx(not_nan_inds) = not_nan_vx;
vy = nan(size(traj.hd_y));
vy(not_nan_inds) = not_nan_vy;

vy(1:filter_width) = nan;
vx(1:filter_width) = nan;
vy((-filter_width:0) + length(vy)) = nan;
vx((-filter_width:0) + length(vx)) = nan;


vel.x = vx;
vel.y = vy;


