function [head_v_corr, vel] = headVelocityCorr(traj)


%Will just trim the Nans for now. not exactly kosher, but there aren't too
%many of them. Also, will look at the correlation between x, vx, and y, vy
%separately.

not_nan_inds = isfinite(traj.posx + traj.posy + traj.hd_x + traj.hd_y);


filter_width = 75;
my_filter = fspecial('gaussian', [(2 * filter_width + 1) 1], 25);

my_filter = my_filter .* ((-filter_width):filter_width)';

not_nan_x = traj.posx(not_nan_inds);
not_nan_y = traj.posy(not_nan_inds);
not_nan_hdx = traj.hd_x(not_nan_inds);
not_nan_hdy = traj.hd_y(not_nan_inds);

not_nan_vx = imfilter(not_nan_x, my_filter);
not_nan_vy = imfilter(not_nan_y, my_filter);


hdx_vx_corr_matrix = corrcoef(not_nan_hdx, not_nan_vx);
hdy_vy_corr_matrix = corrcoef(not_nan_hdy, not_nan_vy);

hdx_vx_corr = hdx_vx_corr_matrix(2,1);
hdy_vy_corr = hdy_vy_corr_matrix(2,1);

head_v_corr = .5 * (hdx_vx_corr + hdy_vy_corr);%Positive is counter clockwise, because the mouse moves north when its position is east, 


v_dot_head_dr = not_nan_vx .* not_nan_hdx + not_nan_vy .* not_nan_hdy;
frac_aligned = nanmean(v_dot_head_dr > 0);
fprintf('Head Vel Corr, Frac aligned = %.3f \n', nanmean(v_dot_head_dr > 0));



vx  = nan(size(traj.hd_x));
vx(not_nan_inds) = not_nan_vx;
vy = nan(size(traj.hd_y));
vy(not_nan_inds) = not_nan_vy;


vy(1:100) = nan;
vx(1:100) = nan;
vy((-100:0) + length(vy)) = nan;
vx((-100:0) + length(vx)) = nan;


vel.x = vx;
vel.y = vy;

fprintf('Returning corr %d \n', head_v_corr);

