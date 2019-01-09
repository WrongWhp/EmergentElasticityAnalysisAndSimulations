function [landmark_cell] = MakeMessyLandmarkCell(system, center, cov_radius, strength, use_sharp_mask);


eps = 10^-6;
x_center = center(2);
y_center = center(1);

mesh = system.mesh;
%cov_radius
inv_cov = inv(cov_radius);
%inv_cov
norm_dist_squared =  inv_cov(2,2)  * (mesh.x - x_center).^2 + inv_cov(1,1) * (mesh.y - y_center).^2 + 2 * inv_cov(2,1) * (mesh.y - y_center).*(mesh.x - x_center);
mask = exp(-norm_dist_squared);

mask = mask .* system.in_bounds;

if(1)
    
    [eig_vecs, eig_vals] = eig(cov_radius);
        
    wall_mask = ones(size(mesh.x));
    
    for i = 1
        
        cur_eig_vec = eig_vecs(:, i);
        cur_eig_val = eig_vals(i, i);
        cur_eig_vec;
        cur_eig_val;
        
        cur_inv_cov = cur_eig_vec * cur_eig_vec'/cur_eig_val;
        cur_inv_cov;
        norm_dist_squared = cur_inv_cov(2,2)  * (mesh.x - x_center).^2 + cur_inv_cov(1,1) * (mesh.y - y_center).^2 + 2 * cur_inv_cov(2,1) * (mesh.y - y_center).*(mesh.x - x_center);
        wall_mask = exp(-norm_dist_squared);
        wall_mask = system.in_bounds.*wall_mask;
        wall_mask = wall_mask/max(wall_mask(:));
        %    pause;
    end
    
end

mask = mask  + wall_mask * sum(mask(:))/sum(wall_mask(:)) * (1/2);


landmark_cell = MakeLandmarkCellFromMaskAndStrength(mask, system.rh_graining, strength);


landmark_cell.x_center = x_center;
landmark_cell.y_center = y_center;

landmark_cell.title = 'MakeCircularLandmarkCell';

end
