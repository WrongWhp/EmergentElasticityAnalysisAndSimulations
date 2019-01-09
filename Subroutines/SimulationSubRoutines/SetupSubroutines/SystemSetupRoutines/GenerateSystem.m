%The system object has various arrays to take statistics, as well as
%information about the geometry. 


system.box_size = [sysparams.array_height, sysparams.array_width];
system.times_visited_array = zeros(system.box_size);
system.cond_times_visited = zeros(system.box_size(1), system.box_size(2), sysparams.n_conds + 1);


system.est_xy_accum_array = zeros([system.box_size 2]);
system.est_xy_forcing_array = zeros([system.box_size 2]);
system.est_xy_forcing_strength = zeros([system.box_size]);
system.cond_est_xy_accum_array = zeros([system.box_size 9 2]);


system.z_accum_array = zeros(system.box_size);
system.z_forcing_array = zeros(system.box_size);
system.cond_z_accums = zeros(system.box_size(1), system.box_size(2), sysparams.n_conds+ 1);
    %The last entry is a dummy entry


system.rh_graining = sysparams.rh_graining;
system.rh_accum_array = zeros(system.box_size(1), system.box_size(2), sysparams.rh_graining, sysparams.rh_graining);
system.cond_rh_accum = zeros(system.box_size(1), system.box_size(2), sysparams.rh_graining, sysparams.rh_graining, sysparams.n_conds + 1);

system.rh_V_forcing_array = zeros(system.box_size(1), system.box_size(2), sysparams.rh_graining, sysparams.rh_graining);
system.rh_U_forcing_array = zeros(system.box_size(1), system.box_size(2), sysparams.rh_graining, sysparams.rh_graining);


system.iX_array = (1:sysparams.array_width);
system.iY_array = (1:sysparams.array_height);

system.x_array = (1:sysparams.array_width) * sysparams.spacing;
system.y_array = (1:sysparams.array_height) * sysparams.spacing;
[system.mesh.x, system.mesh.y] = meshgrid(system.x_array, system.y_array);

[system.mesh.iX, system.mesh.iY] = meshgrid(system.iX_array, system.iY_array);





%Populates the boundaries
if(1)
    system.in_bounds = ones(system.box_size);
    for i = 1:length(sysparams.bound_list)
        system.in_bounds = system.in_bounds .* BoundaryImage(system.mesh, sysparams.bound_list{i});
    end
    system.in_bounds = logical(system.in_bounds);
end


CheckSystemBounds
system.out_of_bounds = ~system.in_bounds;


my_edge_filer = ones(3)
filtered_in_bounds = imfilter(system.in_bounds, my_edge_filer, 0);
filtered_out_of_bounds = imfilter(system.out_of_bounds, my_edge_filer, 0);

system.is_inner_boundary = and(filtered_out_of_bounds > min(filtered_out_of_bounds(:)), system.in_bounds);
system.is_outer_boundary = and(filtered_in_bounds > min(filtered_in_bounds(:)), ~system.in_bounds);

system.is_inner_or_outer_boundary = or(system.is_inner_boundary, system.is_outer_boundary);
system.area = sysparams.spacing^2 * (sum(system.in_bounds(:)));


