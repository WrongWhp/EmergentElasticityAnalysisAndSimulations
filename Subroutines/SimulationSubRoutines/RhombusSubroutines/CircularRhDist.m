function [dist] = CircularRhDist(rh_graining, min_allowed_dist)

%Creates a circular mask as a function of (phi_u, phi_v). 

iU = 1:rh_graining;
iV = 1:rh_graining;




[iU_mesh, iV_mesh] = meshgrid(1:rh_graining, 1:rh_graining);

U_shift = [1 1 1 0 0 0 -1 -1 -1];
V_shift = [1 0 -1 1 0 -1 1 0 -1];


distance_cube = zeros(rh_graining, rh_graining, 9);

[base_rh_iY, base_rh_iX] = vu2yx(1, 1);




for shift_ind = 1:9
   shifted_iU_mesh = iU_mesh + rh_graining * U_shift(shift_ind); 
   shifted_iV_mesh = iV_mesh + rh_graining * V_shift(shift_ind); 
    [shifted_rh_iY_mesh, shifted_rh_iX_mesh] = vu2yx(shifted_iV_mesh, shifted_iU_mesh);
 
    shifted_distance = sqrt((shifted_rh_iX_mesh - base_rh_iX).^2 + (shifted_rh_iY_mesh - base_rh_iY).^2);    
    distance_cube(:, :, shift_ind) = shifted_distance;
        
end


min_shift_distance = min(distance_cube, [], 3) /rh_graining;

dist = zeros(rh_graining, rh_graining);
dist(min_shift_distance < min_allowed_dist) = 1;


