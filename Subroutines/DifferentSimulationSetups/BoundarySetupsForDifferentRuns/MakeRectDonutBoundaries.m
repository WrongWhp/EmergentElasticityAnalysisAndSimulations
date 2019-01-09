%Y Boundaries
donut_min_y = 1;
donut_max_y = 6;%Was 7
donut_min_x = 1;
donut_max_x = 13;
donut_max_x = 10;

sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([1 0], [donut_min_y 0]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([-1 0], [donut_max_y 0]);
 
%X Boundaries
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 1], [0 donut_min_x]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 -1], [0 donut_max_x]);


x_corridor_thickness = 1.5;
y_corridor_thickness=  2.0;
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(donut_min_x + 	x_corridor_thickness , donut_max_x - x_corridor_thickness , donut_min_y + y_corridor_thickness , donut_max_y - y_corridor_thickness);