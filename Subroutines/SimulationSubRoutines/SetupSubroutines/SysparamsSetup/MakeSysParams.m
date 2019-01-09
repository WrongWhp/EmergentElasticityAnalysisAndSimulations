%%%%Sets all parameters


sysparams.sharp_landmark_masks = true;


sysparams.n_conds = 8;
sysparams.steps_per_pixel = 400;
sysparams.width = 10; %Width in dimensionless units(Grid Cell Radians)
sysparams.height = 10; %Height in dimensionless units(Grid Cell Radians)
sysparams.rh_graining = 15;
sysparams.graining = 10;
%sysparams.force_mult = .1;
sysparams.force_mult = .5;
sysparams.folder_path = 'Outputssss/Output/'; %Default If we dont end up changing it
sysparams.n_runs = 20;


sysparams.verbose.output_landmark_fields = false;
sysparams.verbose.output_landmark_states = false;

sysparams.verbose.output_rh_dists = false;

sysparams.verbose.output_z_fields = true;
sysparams.verbose.output_system_states = true;
sysparams.verbose.output_cond_dists = false;

sysparams.stripe_phase_shifts =  exp(2 * pi * j  * (0:0)); %For display purposes, we can plot many phase shifts and then choose the best one
sysparams.landmark_cell_radius = 1;
%sysparams.rh_graining = 15;
%sysparams.graining = 10;

sysparams.rh_u_shift_list = 0:.5:.8;
sysparams.rh_v_shift_list = 0:.5:.8;









