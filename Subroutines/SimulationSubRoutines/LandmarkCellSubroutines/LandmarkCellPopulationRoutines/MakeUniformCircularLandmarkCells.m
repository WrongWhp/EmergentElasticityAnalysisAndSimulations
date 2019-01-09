

landmark_cell_list = {}

landmark_cell_cover_radius  = sysparams.landmark_cell_radius;
%landmark_cell_cover_radius = 1.3;
landmark_cell_base_strength = 1;

for iX = 1:sysparams.array_width
    for iY = 1:sysparams.array_height
        i_posit = [iY, iX];
        
        cur_posit = [system.y_array(iY) system.x_array(iX)];
        landmark_cell_strength = (sysparams.spacing^2) * landmark_cell_base_strength/(pi * landmark_cell_cover_radius^2);
        
        proposed_landmark_cell = MakeCircularLandmarkCell(system, cur_posit, landmark_cell_cover_radius, landmark_cell_strength, sysparams.sharp_landmark_masks);
        if(sum(proposed_landmark_cell.mask(:) .* system.in_bounds(:)) > 0)
            landmark_cell_list{length(landmark_cell_list)+1} = proposed_landmark_cell;
        end
        
    end
end

 
