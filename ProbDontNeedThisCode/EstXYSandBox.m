com_iX = round(mean(system.mesh.iX(system.in_bounds)));
com_iY = round(mean(system.mesh.iY(system.in_bounds)));


system.cond_est_xy_accum_array(:, :, 9, 1)./system.times_visited_array;

cond_est_y = system.cond_est_xy_accum_array(:, :, 1:8, 2)./system.cond_times_visited(:, :, 1:8);
cond_est_x = system.cond_est_xy_accum_array(:, :, 1:8, 1)./system.cond_times_visited(:, :, 1:8);

fprintf('Max x range is %f, min is %f \n',  max(cond_est_x(:)), min(cond_est_x(:)));
fprintf('Max y range is %f, min is %f \n',  max(cond_est_y(:)), min(cond_est_y(:)));

est_y = system.est_xy_accum_array(:, :, 2)./system.times_visited_array;
est_x = system.est_xy_accum_array(:, :, 1)./system.times_visited_array;

fprintf('Max x range is %f, min is %f \n',  max(est_x(:)), min(est_x(:)));
fprintf('Max y range is %f, min is %f \n',  max(est_y(:)), min(est_y(:)));


y_cond_diff = cond_est_y(com_iY, com_iX, 6) - cond_est_y(com_iY, com_iX, 5); 
x_cond_diff = cond_est_x(com_iY, com_iX, 8) - cond_est_x(com_iY, com_iX, 7); 


fprintf('EstX_diff is %f \n', x_cond_diff);
fprintf('EstY_diff is %f \n', y_cond_diff);

x_cond_diff_list(run_num) = x_cond_diff;
y_cond_diff_list(run_num) = y_cond_diff;