%Y Boundaries
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([1 0], [1 0]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([-1 0], [11 0]); 
%X Boundaries
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 1], [0 1]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 -1], [0 11]);
