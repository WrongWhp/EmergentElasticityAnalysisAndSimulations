function[clock_mask] = ClockMask(x, y, angle);
%Helper function for making clock images. 

x = x - mean(x(:));
y = y - mean(y(:));


rotated_x  = cos(angle) * x +sin(angle) * y;
rotated_y = -sin(angle) * x+ cos(angle) * y;

radius_to_use = max(y(:));


clock_width = .045 *radius_to_use;
clock_length = .95 * radius_to_use;
clock_mask = and( IsBetween(-rotated_y, 0, clock_length), IsBetween(rotated_x, -clock_width, clock_width));

