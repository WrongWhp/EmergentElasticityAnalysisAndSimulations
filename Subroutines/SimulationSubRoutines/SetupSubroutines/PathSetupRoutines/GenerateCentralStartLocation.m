
fprintf('Generating central starting location ...   ');

mean_x_in_box = mean(system.mesh.x(logical(system.in_bounds)));
mean_y_in_box = mean(system.mesh.y(logical(system.in_bounds)));

x_dist_squared = (system.mesh.x -mean_x_in_box).^2;
y_dist_squared = (system.mesh.y - mean_y_in_box).^2;

total_dist_squared = x_dist_squared + y_dist_squared;

[min_dist, arg_min_dist] = min(total_dist_squared(:));
close_to_cm_y = system.mesh.y(arg_min_dist);
close_to_cm_x = system.mesh.x(arg_min_dist); %Pick the x and y that are the closest to the center of mass

path.start_location = round(sysparams.graining * [close_to_cm_y, close_to_cm_x]);


fprintf('Finished ! \n');