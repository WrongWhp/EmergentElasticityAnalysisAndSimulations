function [landmark_cell] = MakeEllipseLandmarkCell(system, center, cov_radius, strength, use_sharp_mask);


eps = 10^-6;
x_center = center(2);
y_center = center(1);

mesh = system.mesh;
%cov_radius
inv_cov = inv(cov_radius);
%inv_cov
norm_dist_squared =  inv_cov(2,2)  * (mesh.x - x_center).^2 + inv_cov(1,1) * (mesh.y - y_center).^2 + 2 * inv_cov(2,1) * (mesh.y - y_center).*(mesh.x - x_center);
if(use_sharp_mask)
    mask = double(norm_dist_squared < (1 + eps));
else
    mask = exp(-norm_dist_squared);    
end

landmark_cell = MakeLandmarkCellFromMaskAndStrength(mask, system.rh_graining, strength);


landmark_cell.x_center = x_center;
landmark_cell.y_center = y_center;

landmark_cell.title = 'MakeCircularLandmarkCell';

end
