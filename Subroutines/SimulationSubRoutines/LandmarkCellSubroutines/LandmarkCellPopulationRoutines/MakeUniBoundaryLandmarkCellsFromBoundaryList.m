


landmark_cell_base_strength = sysparams.force_mult;
landmark_cell_cover_radius = sysparams.landmark_cell_radius;


for i_bound = 1:length(sysparams.bound_list)
    cur_boundary  = sysparams.bound_list{i_bound};
    fprintf('i_bound is %f \n', i_bound);
    if(strcmp(cur_boundary.type, 'LinearBoundary'))
        cur_objective = cur_boundary.objective;
        cur_base_point = cur_boundary.sample_point;
        cur_norm_obj = -cur_objective/norm(cur_objective);
        parallel_bound_vec = rotateAndNormalize(cur_objective);
        
        max_offset = 2 * max(sysparams.width, sysparams.height);
        
        
        landmark_cell_mask = ones(system.box_size);
        
        landmark_cell_mask = landmark_cell_mask .*LinearBoundaryImage(system.mesh, cur_boundary);
        landmark_cell_mask = landmark_cell_mask .*LinearBoundaryImage(system.mesh, MakeLinearBoundaryObject(cur_norm_obj, cur_boundary.sample_point - landmark_cell_cover_radius * cur_norm_obj));
        
        
        
        cur_landmark_cell = MakeLandmarkCellFromMaskAndStrength(landmark_cell_mask, sysparams.rh_graining, landmark_cell_base_strength);
        landmark_cell_list{length(landmark_cell_list)+1} = cur_landmark_cell;
        cur_landmark_cell.title = 'MakeUniBoundaryLandmarkCellsFromBoundaryList';
        
    end
    
end


