function [output] = MakeInteriorRectangleBoundaryObject(min_x, max_x, min_y, max_y);


output.type = 'InteriorRectangleBoundary';

output.min_x  = min_x;
output.max_x = max_x;
output.min_y = min_y;
output.max_y = max_y;
