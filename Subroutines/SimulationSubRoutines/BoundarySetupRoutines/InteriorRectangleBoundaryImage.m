function [output] = InteriorRectangleBoundaryImage(mesh, interior_rectangle_boundary);


ok_x = IsBetween(mesh.x, interior_rectangle_boundary.min_x, interior_rectangle_boundary.max_x);
ok_y = IsBetween(mesh.y, interior_rectangle_boundary.min_y, interior_rectangle_boundary.max_y);
output = ~and(ok_x, ok_y);