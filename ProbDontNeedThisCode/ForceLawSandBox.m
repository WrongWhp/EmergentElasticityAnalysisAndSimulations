
close all
clear all;
addAllPaths



for i = 1:1000
    sysparams.rh_graining = 9;
    force_v = rand() * 1;
    cur_rh_vu = [force_v rand()];
    cur_rh_dist_struct = RhToDist(cur_rh_vu, sysparams.rh_graining);
    
    
    other_rh_vu = [.0 .1];
    other_rh_dist_struct = RhToDist(other_rh_vu, sysparams.rh_graining);
    if(1)
        permuted_weight_array =  cur_rh_dist_struct.weight_array;
        rh_accum_array = zeros(sysparams.rh_graining, sysparams.rh_graining);
        rh_accum_array(cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range) =  ...
            rh_accum_array(cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range)  + permuted_weight_array;
        [v_force, u_force] =  ForceArrayFromRhDist(rh_accum_array);
        
        
        local_v_force = v_force(other_rh_dist_struct.iV_range, other_rh_dist_struct.iU_range);
        v_force = mean(local_v_force(:) .* other_rh_dist_struct.weight_array(:));
        %        cur_U_force = mean(local_U_force(:) .* permuted_weight_array(:));
        
        
    end
    
    
    input_v_list(i) = force_v;
    output_v_list(i) = v_force;
end

close all
scatter(input_v_list, output_v_list, '.')
if(0)
    permuted_weight_array = permute(cur_rh_dist_struct.weight_array, [3 4 1 2]);
    
    rh_accum_array = zeros(1, 1, sysparams.rh_graining, sysparams.rh_graining);
    rh_accum_array(1, 1, cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range) =  ...
        rh_accum_array(1, 1, cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range)  + permuted_weight_array;
end