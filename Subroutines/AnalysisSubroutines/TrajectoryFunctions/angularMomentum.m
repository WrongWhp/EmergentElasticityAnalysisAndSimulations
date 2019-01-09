function [ang_momentum] = angularMomentum(traj)


%Will just trim the Nans for now. not exactly kosher, but there aren't too
%many of them. 

not_nan_inds = isfinite(traj.posx + traj.posy);


filter_width = 75;
my_filter = fspecial('gaussian', [(2 * filter_width + 1) 1], 25);

my_filter = my_filter .* ((-filter_width):filter_width)';

not_nan_x = traj.posx(not_nan_inds);
not_nan_y = traj.posy(not_nan_inds);

vx = imfilter(not_nan_x, my_filter);
vy = imfilter(not_nan_y, my_filter);

x_vy_corr_matrix = corrcoef(not_nan_x, vy);
y_vx_corr_matrix = corrcoef(not_nan_y, vx);

x_vy_corr = x_vy_corr_matrix(2,1);
y_vx_corr = y_vx_corr_matrix(2,1);

ang_momentum = .5 * (x_vy_corr - y_vx_corr);%Positive is counter clockwise, because the mouse moves north when its position is east, 





