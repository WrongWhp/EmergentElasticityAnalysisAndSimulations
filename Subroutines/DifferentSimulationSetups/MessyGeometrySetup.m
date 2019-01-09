%[.005 .01 .05 .2 .5 1 2]

for cur_force_mult = .18:.05:.4;
    %[.4 .6 .8 1.5 ]
    %    for cur_force_mult = [.075 .1 .15 .4 .8]
    %Clear out old stuff that's not needed
    clear system
    clear path
    clear sysparams
    
    
    MakeSysParams %A lot of defaults are set by this.
    sysparams.graining = 2;
    sysparams.width = 12;
    sysparams.height = 12;
    sysparams.rh_graining = 13;
    sysparams.n_runs = 20;
    sysparams.steps_per_pixel = 250; %Average number of times the mouse will step foot in each pixel
    sysparams.force_mult = cur_force_mult;
    
    
    
    sysparams.verbose.output_landmark_fields = false;
    sysparams.verbose.output_system_states = true;
    sysparams.verbose.output_rh_dists= false;
    sysparams.verbose.output_cond_dists = false;
    sysparams.landmark_cell_radius = .3
    
    MakeSysParamsHelpers %The sysparams struct has some redundant information which is created here
    
    %wave_vector = [1 3^.5];
    %wave_vector = [1 3^.5] * 2;
    sysparams.wave_vec = [0 1] * 2 * 1;
    %        sysparams.wave_vec = [0 1] * 2;
    sysparams.rh_wave_vec = 2.;
    sysparams.rh_rot_angle = .0;
    sysparams.folder_path = sprintf('../Outputs/MessyGeometry/StrengthVar/Graining%d/WaveVec%f/ArchOutputStrength%f/', sysparams.graining, sysparams.rh_wave_vec , cur_force_mult);
    
    
    sysparams.bound_list = {};
    
    MakeSquareBoundaries
    
    %        MakeSquareBoundaries
    %        sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(3, 7, 3, 7);
    %        sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(3.6, 6.4, 3.6, 6.4);
    
    
    
    should_keep_generating_rectangles = 1;
    
    while(should_keep_generating_rectangles)
        landmark_cell_list = {}
        sysparams.bound_list = {};
        MakeMessyBoundaries
        GenerateSystem
        conn_comp = bwconncomp(system.in_bounds);
        should_keep_generating_rectangles = conn_comp.NumObjects ~= 1;
    end
    
    %    MakeUniBoundaryLandmarkCellsFromBoundaryList
    %        MakeCircularLandmarkCellsFromBoundaryList;
    %        MakeUniformCircularLandmarkCells;
    MakeCircularLandmarkCellsFromBoundaryList
    
    
    for i_landmark = 1:length(landmark_cell_list)
        new_vu = mod([rand(), rand()], 1);
        cur_landmark_cell = landmark_cell_list{i_landmark}
        cur_landmark_cell.rh_dist_array = RhVUToDistArray(new_vu,  sysparams.rh_graining);
        [cur_landmark_cell.rh_V_forcing, cur_landmark_cell.rh_U_forcing] = ForceArrayFromRhDist(cur_landmark_cell.rh_dist_array);
        cur_landmark_cell.learned_z = exp(2*pi*j * rand());
        cur_landmark_cell.learned_xy = [rand(), rand()] .* [sysparams.width, sysparams.height];
        landmark_cell_list{i_landmark} = cur_landmark_cell;
        
    end
    
    UpdateForcingArray
    Run2DAttractSysParams; %Most of the meat in here
end
