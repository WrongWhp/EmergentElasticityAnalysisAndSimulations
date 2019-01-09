


landmark_cell_base_strength = sysparams.force_mult;

for i_bound = 1:length(sysparams.bound_list)
   cur_boundary  = sysparams.bound_list{i_bound}
   fprintf('i_bound is %f \n', i_bound);
   if(strcmp(cur_boundary.type, 'LinearBoundary'))
       cur_obj = cur_boundary.objective;
       cur_base_point = cur_boundary.sample_point;
       parallel_bound_vec = rotateAndNormalize(cur_obj);
       
       max_offset = 2 * max(sysparams.width, sysparams.height);
       %Just casting a wide net. We iterate along more of the boundary than
       %actually exists
       
       for base_point_offset = (-max_offset):sysparams.spacing:max_offset
           base_point_offset;
           cur_posit = cur_base_point  +  base_point_offset * parallel_bound_vec;
           cur_posit
%           landmark_cell_cover_radius  = sysparams.landmark_cell_radius *( eye(2)  + (sysparams.ellipse_asp_ratio -1) *  parallel_bound_vec' * parallel_bound_vec);
           landmark_cell_cover_radius  = sysparams.landmark_cell_radius^2 *( eye(2)  + (sysparams.ellipse_asp_ratio^2 -1) *  parallel_bound_vec' * parallel_bound_vec);
           
           
           i_posit = round(cur_posit * sysparams.graining);
           
           if(InBoundsCoords(i_posit, system.box_size))
               if(system.is_inner_or_outer_boundary(i_posit(1), i_posit(2)) || 1)
                   
                    fprintf('Making a landmark cell! \n');
                               
                     
                    proposed_landmark_cell = MakeMessyLandmarkCell(system, cur_posit, landmark_cell_cover_radius, sysparams.spacing * landmark_cell_base_strength, sysparams.sharp_landmark_masks);
                    if(sum(proposed_landmark_cell.mask(:) .* system.in_bounds(:)) > 0)
                        landmark_cell_list{length(landmark_cell_list)+1} = proposed_landmark_cell;
                    end
               end
           end
       end
       
   end
    
end

