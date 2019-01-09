

landmark_cell_list = {}

landmark_cell_cover_radius  = sysparams.landmark_cell_radius;

if(1)
    for iX = 1:sysparams.array_width
        for iY = 1:sysparams.array_height
            clear cur_landmark_cell
            if(system.is_inner_boundary(iY, iX) or system.is_outer_boundary(iY, iX))                
                landmark_cell_list{ind_to_add} = MakeCircularLandmarkCell(system, landmark_cell_cover_radius, landmark_cell_cover_radius, sysparams.force_mult/sysparams.graining)  ;
            end
        end
    end
    
else
    for iX = 1:sysparams.array_width
        for iY = 1:sysparams.array_height
            clear cur_landmark_cell
            if(system.is_boundary(iY, iX))
                cur_landmark_cell = 
                cur_landmark_cell.x_center = system.x_array(sysparams.array_width/2);
                cur_landmark_cell.y_center = system.y_array(sysparams.array_width/2);
                dist_squared = (system.mesh.x - cur_landmark_cell.x_center).^2 + (system.mesh.y - cur_landmark_cell.y_center).^2;
                cur_landmark_cell.mask = dist_squared < 3;
                
                ind_to_add = length(landmark_cell_list) + 1;
                
                cur_landmark_cell.strength = 1;
                cur_landmark_cell.learned_z = 0;
                landmark_cell_list{ind_to_add} = cur_landmark_cell;
            end
        end
    end
        
end
