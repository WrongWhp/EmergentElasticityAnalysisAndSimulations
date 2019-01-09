%Y Boundaries
donut_min_y = 1;
donut_max_y = 11;
donut_min_x = 1;
donut_max_x = 11;

sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([1 0], [donut_min_y 0]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([-1 0], [donut_max_y 0]);
 
%X Boundaries
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 1], [0 donut_min_x]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 -1], [0 donut_max_x]);



for n_landmark = 1:8
    com_from_wall_thresh = 0;
    new_center_x = donut_min_x + .5 * com_from_wall_thresh  + (donut_max_x -donut_min_x - com_from_wall_thresh) * rand();
    new_center_y = donut_min_y  +.5 * com_from_wall_thresh +  (donut_max_y -donut_min_y - com_from_wall_thresh) * rand();    
    new_r_x = (1.5 + 0*PMOne())/1;
    new_r_y = 3 -new_r_x;
    if(n_landmark>4)
       new_r_x = 1;
       nr_r_y = 1;
    end
    sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(new_center_x-new_r_x, new_center_x + new_r_x, new_center_y-new_r_y, new_center_y +new_r_y);    
end

%sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(donut_min_x  + 2 , donut_max_x - corridor_thickness , donut_min_y + corridor_thickness , donut_max_y - corridor_thickness);


%corridor_thickness = 1.5;
%sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(donut_min_x + 	corridor_thickness , donut_max_x - corridor_thickness , donut_min_y + corridor_thickness , donut_max_y - corridor_thickness);