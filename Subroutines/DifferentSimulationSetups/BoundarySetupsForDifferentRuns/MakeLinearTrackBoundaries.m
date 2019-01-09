%Y Boundaries
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([1 0], [sysparams.spacing * 1.5 0]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [-1 0], [sysparams.spacing * 2.5, 0]);

%X Boundaries
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject( [0 1], [0 sysparams.spacing * 1.5]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([0 -1], [0 sysparams.width - .5 * sysparams.spacing]);
