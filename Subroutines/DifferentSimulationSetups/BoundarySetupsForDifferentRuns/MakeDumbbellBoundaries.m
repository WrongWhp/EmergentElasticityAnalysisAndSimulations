%Y Boundaries
donut_min_y = 1.00;
donut_max_y = 6.00;
donut_min_x = 1.0;
donut_max_x = 11;

sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([1 0], [donut_min_y 0]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([-1 0], [donut_max_y 0]);
 
%X Boundaries
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 1], [0 donut_min_x]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 -1], [0 donut_max_x]);



sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(4.5, 7.5, 0, donut_max_y - .3);    

%sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(7.5, 12, 2, 10);    


%sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(donut_min_x  + 2 , donut_max_x - corridor_thickness , donut_min_y + corridor_thickness , donut_max_y - corridor_thickness);


%corridor_thickness = 1.5;
%sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(donut_min_x + 	corridor_thickness , donut_max_x - corridor_thickness , donut_min_y + corridor_thickness , donut_max_y - corridor_thickness);