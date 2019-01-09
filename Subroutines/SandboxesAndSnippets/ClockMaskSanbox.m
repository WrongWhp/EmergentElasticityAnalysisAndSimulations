clear all
close all;

[x, y] = meshgrid(1:40, 1:40);
x = x - mean(x(:));
y = y - mean(y(:));

rotation_angle = .3;

rotated_x  = cos(rotation_angle) * x +sin(rotation_angle) * y;
rotated_y = -sin(rotation_angle) * x+ cos(rotation_angle) * y;

radius_to_use = max(y(:));


clock_width = .03 *radius_to_use;
clock_length = .8 * radius_to_use;
within_bounds = and( IsBetween(-rotated_y, 0, clock_length), IsBetween(rotated_x, -clock_width, clock_width));

imshow(within_bounds);





%rotate(x, y, 40)
