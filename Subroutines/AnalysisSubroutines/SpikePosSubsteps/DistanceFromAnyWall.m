function [dist_array] = DistanceFromAnyWall(x, y, x_range, y_range)

distx1 = abs(x - x_range(1));
distx2 = abs(x - x_range(2));
disty1 = abs(y - y_range(1));
disty2 = abs(y - y_range(2));

x_min_dist = min(distx1, distx2);
y_min_dist = min(disty1, disty2);
dist_array = min(x_min_dist, y_min_dist);