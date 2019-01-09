


for cur_force_mult = [.2 .4 .8 1.6];
    %Simple TEst
    %    for cur_force_mult = [.075 .1 .15 .4 .8]
    %Clear out old stuff that's not needed
    clear system
    clear path
    clear sysparams
    
    
    MakeSysParams %A lot of defaults are set by this.
    sysparams.graining = 4;
    sysparams.width = 10;
    sysparams.height = 10;
    sysparams.rh_graining = 15;
    %    sysparams.rh_graining = 9;
    
    sysparams.n_runs = 10;
    sysparams.steps_per_pixel = 300; %Average number of times the mouse will step foot in each pixel
    sysparams.force_mult = cur_force_mult;
    sysparams.folder_path = sprintf('../Outputs/Trapezoid/StrengthVar/Graining%d/ArchOutputStrength%f', sysparams.graining, cur_force_mult);
    
    sysparams.verbose.output_landmark_fields = false;
    sysparams.verbose.output_landmark_states = false;
    sysparams.verbose.output_system_states = false;
    sysparams.verbose.output_rh_dists= false;
    sysparams.verbose.output_cond_dists = false;
    MakeSysParamsHelpers %The sysparams struct has some redundant information which is created here
    
    
    sysparams.wave_vec = [1 0] * 2;
    sysparams.rh_wave_vec = 1.3 * 2* pi/3;
    sysparams.rh_rot_angle = 0;
    sysparams.landmark_cell_radius = .4;    
    
    
    
    %%Maakes the boundaries
    sysparams.bound_list = {};
    %    MakeSquareBoundaries
    MakeTrapezoidBoundaries
    GenerateSystem
    %    PopulateLandmarkCells
    landmark_cell_list = {};
    if(1)
        MakeUniBoundaryLandmarkCellsFromBoundaryList;
        for i = 1:length(landmark_cell_list)
           cur_landmark_cell = landmark_cell_list{i}; 
           cur_landmark_cell.strength = cur_landmark_cell.strength*.5;
        end
    end
    MakeCircularLandmarkCellsFromBoundaryList;
    OutputLandmarkCellFiringFields 
    Run2DAttractSysParams; %Most of the meat in here
end

