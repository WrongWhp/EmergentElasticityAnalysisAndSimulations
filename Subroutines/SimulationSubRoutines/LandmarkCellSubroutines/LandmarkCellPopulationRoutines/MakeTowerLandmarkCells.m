
fprintf('At MakeTowerLandmarkCells \n');

landmark_cell_cover_radius  = sysparams.tower_width;
landmark_cell_base_strength = sysparams.force_mult;

y_to_use = mean(system.mesh.y(system.in_bounds));


tower_x_centers = 0:sysparams.tower_spacing:sysparams.width
for tower_ind = 1:length(tower_x_centers)
    cur_tower_x = tower_x_centers(tower_ind)
    cur_landmark_COM = [y_to_use cur_tower_x];
    proposed_landmark_cell = MakeCircularLandmarkCell(system, cur_landmark_COM, sysparams.tower_width, sysparams.force_mult, sysparams.use_sharp_mask);
    proposed_landmark_cell.tower_ind = tower_ind;
    
    if(sum(proposed_landmark_cell.mask(:) .* system.in_bounds(:)) > 0)
        landmark_cell_list{length(landmark_cell_list)+1} = proposed_landmark_cell;
    end
end
