function [output] = LinearBoundaryImage(mesh, objective, sample_point);


dot_product = mesh.y * objective(1) + mesh.x * objective(2);



min_dot_product = objective(1) * sample_point(1) + objective(2) * sample_point(2);

output =  (dot_product >= min_dot_product);
