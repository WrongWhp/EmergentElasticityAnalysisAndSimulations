function [output] = LinearBoundaryImage(mesh, boundary_obj);



eps = 10^-6;
dot_product = mesh.y * boundary_obj.objective(1) + mesh.x * boundary_obj.objective(2);
min_dot_product = boundary_obj.objective(1) * boundary_obj.sample_point(1) + boundary_obj.objective(2) * boundary_obj.sample_point(2);
output =  ((dot_product + eps) >= min_dot_product);



