function [landmark_cell] = MakeRectangleLandmarkCell(system, center, cov_radius, strength);


eps = 10^-6;
x_center = center(2);
y_center = center(1);

mesh = system.mesh;
%cov_radius


%Takes a covariance and gives a rectangle, not an ellipse.


[eig_vecs, eig_vals] = eig(cov_radius);


mask = ones(size(mesh.x));

for i = 1:2
    
    cur_eig_vec = eig_vecs(:, i);
    cur_eig_val = eig_vals(i, i);
    cur_eig_vec;
    cur_eig_val;
    
    cur_inv_cov = cur_eig_vec * cur_eig_vec'/cur_eig_val;
    cur_inv_cov
    norm_dist_squared = cur_inv_cov(2,2)  * (mesh.x - x_center).^2 + cur_inv_cov(1,1) * (mesh.y - y_center).^2 + 2 * cur_inv_cov(2,1) * (mesh.y - y_center).*(mesh.x - x_center);
    mask = mask .*  (norm_dist_squared < ( 1+eps));
%    pause;
end

mask = mask > 0;
landmark_cell = MakeLandmarkCellFromMaskAndStrength(mask, system.rh_graining, strength);


landmark_cell.x_center = x_center;  
landmark_cell.y_center = y_center;

landmark_cell.title = 'MakeCircularLandmarkCell';

end
