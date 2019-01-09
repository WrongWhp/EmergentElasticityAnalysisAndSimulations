
%size_mult = 2 * 1.9/(1.6);

size_mult = 1;

%Y Boundaries

sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([1 0], size_mult *[1 0]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([-1 0], size_mult *[7 0]);

%X Boundaries
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([0 1], size_mult *[0 1.]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([0 -1],size_mult * [0 20]);

%sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([2.5 1], size_mult * [2 5]);

%Diag Boundary
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([4.2 1], size_mult * [1 11]);
sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeLinearBoundaryObject([-4.2 1], size_mult * [7 11]);


%Lower boundary
