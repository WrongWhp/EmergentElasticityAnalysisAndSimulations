function [V_force, U_force] = CenteredForceArray(rh_graining)
%Constructs a table of Force(phi_u, phi_v)

iU = 1:rh_graining;
iV = 1:rh_graining;
[iU_mesh, iV_mesh] = meshgrid(1:rh_graining, 1:rh_graining);

U_shift = [1 1 1 0 0 0 -1 -1 -1];
V_shift = [1 0 -1 1 0 -1 1 0 -1];

distance_cube = zeros(rh_graining, rh_graining, 9);
[base_rh_iY, base_rh_iX] = vu2yx(1, 1);

U_force_cube = zeros(rh_graining, rh_graining, 9);
V_force_cube = zeros(rh_graining, rh_graining, 9);





for shift_ind = 1:9
   shifted_iU_mesh = iU_mesh + rh_graining * U_shift(shift_ind); 
   shifted_iV_mesh = iV_mesh + rh_graining * V_shift(shift_ind); 
    [shifted_rh_iY_mesh, shifted_rh_iX_mesh] = vu2yx(shifted_iV_mesh, shifted_iU_mesh);
    
    shifted_delta_rh_Y_mesh = (shifted_rh_iY_mesh - base_rh_iY)/rh_graining;
    shifted_delta_rh_X_mesh = (shifted_rh_iX_mesh - base_rh_iX)/rh_graining;
 
    shifted_distance = sqrt((shifted_delta_rh_Y_mesh).^2 + (shifted_delta_rh_X_mesh).^2);    
    distance_cube(:, :, shift_ind) = shifted_distance;
    
    shifted_force_mag = AttractorNetworkForceLaw(shifted_distance);
    
    shifted_rh_Y_force = shifted_force_mag .*shifted_delta_rh_Y_mesh ./(shifted_distance + realmin);
    shifted_rh_X_force = shifted_force_mag .*shifted_delta_rh_X_mesh ./(shifted_distance + realmin);
    
    
    shifted_force_mag;
    
    [shifted_V_force, shifted_U_Force] = yx2vu(shifted_rh_Y_force, shifted_rh_X_force);
    V_force_cube(:, :, shift_ind) = shifted_V_force;
    U_force_cube(:, :, shift_ind) = shifted_U_Force;
end


[min_shift_distance min_shift_ind]  = min(distance_cube, [], 3);

for iV = 1:rh_graining
    for iU = 1:rh_graining
        V_force(iV, iU) = V_force_cube(iV, iU, min_shift_ind(iV, iU));
        U_force(iV, iU) = U_force_cube(iV, iU, min_shift_ind(iV, iU));               
    end    
end

V_force(V_force == 0) = 0; %We get rid of negative zeros for aesthetic purposes
U_force(U_force == 0) = 0;
