


for cur_force_mult = [.1 .2 .4 .6];
    %Simple TEst
    %    for cur_force_mult = [.075 .1 .15 .4 .8]
    %Clear out old stuff that's not needed
    clear system
    clear path
    clear sysparams
    
    
    MakeSysParams %A lot of defaults are set by this.
    sysparams.graining = 3;
    sysparams.width = 10;
    sysparams.height = 10;
%    sysparams.rh_graining = 19;
        sysparams.rh_graining = 13;
    
    sysparams.n_runs = 20;
    sysparams.steps_per_pixel = 100; %Average number of times the mouse will step foot in each pixel
    sysparams.force_mult = cur_force_mult;
    
    sysparams.verbose.output_landmark_fields = false;
    sysparams.verbose.output_landmark_states = false;
    sysparams.verbose.output_system_states = false;
    sysparams.verbose.output_rh_dists= false;
    sysparams.verbose.output_cond_dists = false;
    MakeSysParamsHelpers %The sysparams struct has some redundant information which is created here
    
    
    sysparams.wave_vec = [2 0] * 2;
    sysparams.rh_wave_vec = 1.4 *  2* pi/5;
    sysparams.rh_rot_angle = 1 * .14;
    
    
    sysparams.folder_path = sprintf('../Outputs/SquareShear/Graining%d/Rotation%f/StrengthVar/ArchOutputStrength%f',  sysparams.graining, sysparams.rh_rot_angle, cur_force_mult);
    
    
    %%Maakes the boundaries
    if(0)
        sysparams.bound_list = {};
        MakeSquareBoundaries
        %    MakeTrapezoidBoundaries
        GenerateSystem
        %    PopulateLandmarkCells
        landmark_cell_list = {};
        MakeCircularLandmarkCellsFromBoundaryList;
        %MakeUniBoundaryLandmarkCellsFromBoundaryList;
        
    else
        sysparams.landmark_cell_radius = .4;
        sysparams.bound_list = {};
        MakeSquareBoundaries
        %    MakeTrapezoidBoundaries
        GenerateSystem
        %    PopulateLandmarkCells
        landmark_cell_list = {};
        %    MakeCircularLandmarkCellsFromBoundaryList;
        tmp_square_boundaries = sysparams.bound_list;
%        sysparams.bound_list = {tmp_square_boundaries{1}, tmp_square_boundaries{2}};
%        MakeUniBoundaryLandmarkCellsFromBoundaryList;
%        MakeUniBoundaryLandmarkCellsFromBoundaryList;
        MakeUniBoundaryLandmarkCellsFromBoundaryList;
        
        MakeCircularLandmarkCellsFromBoundaryList
        sysparams.bound_list = tmp_square_boundaries;                
    end
    
    Run2DAttractSysParams; %Most of the meat in here
end

