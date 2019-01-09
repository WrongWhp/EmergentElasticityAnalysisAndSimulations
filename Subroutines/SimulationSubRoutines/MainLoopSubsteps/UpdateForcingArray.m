

%We then calculate the total forcing at each position based on the states
%of the landmark cells. 


fprintf('Making forcing array from accum arrays \n');
system.z_forcing_array = 0 * system.z_forcing_array;
system.rh_U_forcing_array = system.rh_U_forcing_array * 0;
system.rh_V_forcing_array = system.rh_V_forcing_array * 0;

tmp_xy_forcing_accum = 0 * system.est_xy_forcing_array; %We add to this matrix and then normalize it at the end
tmp_xy_forcing_strength_accum = zeros(size(system.mesh.x));


for i = 1:length(landmark_cell_list)
    cur_landmark_cell = landmark_cell_list{i};

    %The Z forcing is easy, we just add up all the learned zs times the
    %landmark strength
    system.z_forcing_array = system.z_forcing_array+ cur_landmark_cell.mask * cur_landmark_cell.learned_z * cur_landmark_cell.strength;

    
    %Updates the XY Forcing. Each  `
    if(~isnan(sum(cur_landmark_cell.learned_xy)))
       for i_xy = 1:2
           cur_forcing_slice = tmp_xy_forcing_accum(:, :, i_xy);
           cur_forcing_slice = cur_forcing_slice + cur_landmark_cell.mask *cur_landmark_cell.strength * cur_landmark_cell.learned_xy(i_xy);
           tmp_xy_forcing_accum(:, :, i_xy)  = cur_forcing_slice;
       end
       tmp_xy_forcing_strength_accum = tmp_xy_forcing_strength_accum + cur_landmark_cell.mask *cur_landmark_cell.strength;    
    end
    
    
    for rh_iV = 1:sysparams.rh_graining
        for rh_iU = 1:sysparams.rh_graining
            
            %Adds the V Force
            cur_rh_VForce_subarray = system.rh_V_forcing_array(:, :, rh_iV, rh_iU); %Count of that iU and iV for each possible mouse position
            cur_rh_VForce_subarray = cur_rh_VForce_subarray + cur_landmark_cell.mask* cur_landmark_cell.rh_V_forcing(rh_iV, rh_iU) * cur_landmark_cell.strength;
            permuted_rh_VForce_subarray = permute(cur_rh_VForce_subarray, [3 4 1 2]);
            system.rh_V_forcing_array(:, :, rh_iV, rh_iU) = permuted_rh_VForce_subarray;

            
            %Adds the U Force
            cur_rh_UForce_subarray = system.rh_U_forcing_array(:, :, rh_iV, rh_iU); %Count of that iU and iV for each possible mouse position
            cur_rh_UForce_subarray = cur_rh_UForce_subarray + cur_landmark_cell.mask* cur_landmark_cell.rh_U_forcing(rh_iV, rh_iU) * cur_landmark_cell.strength;
            permuted_rh_UForce_subarray = permute(cur_rh_UForce_subarray, [3 4 1 2]);
            system.rh_U_forcing_array(:, :, rh_iV, rh_iU) = permuted_rh_UForce_subarray;
                        
        end
    end
    
end

system.est_xy_forcing_array = tmp_xy_forcing_accum./cat(3, tmp_xy_forcing_strength_accum, tmp_xy_forcing_strength_accum);
system.est_xy_forcing_strength = tmp_xy_forcing_strength_accum;%We take the accumulator, normalize it, and store the noramlization constant in a forcing strength. 

forcing_zero_out_mask = (tmp_xy_forcing_strength_accum == 0);
system.est_xy_forcing_array(cat(3, forcing_zero_out_mask, forcing_zero_out_mask)) = 0;


fprintf('Finished Updating forcing array \n ');

