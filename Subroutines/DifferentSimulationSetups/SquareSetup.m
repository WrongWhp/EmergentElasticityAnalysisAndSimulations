

for landmark_cell_radius = .5:.25:1.01
    for cur_force_mult = .1:.2:.99;
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
        %    sysparams.rh_graining = 19;
        sysparams.rh_graining = 15;
        
        sysparams.n_runs = 20;
        sysparams.steps_per_pixel = 130; %Average number of times the mouse will step foot in each pixel
        sysparams.force_mult = cur_force_mult;
        sysparams.folder_path = sprintf('../Outputs/AugSquareShift/Graining%d/Radius%f/ArchOutputStrength%f',  sysparams.graining, landmark_cell_radius,  cur_force_mult);
        
        sysparams.verbose.output_landmark_fields = false;
        sysparams.verbose.output_landmark_states = false;
        sysparams.verbose.output_system_states = false;
        sysparams.verbose.output_rh_dists= false;
        sysparams.verbose.output_cond_dists = false;
        MakeSysParamsHelpers %The sysparams struct has some redundant information which is created here
        
        
        sysparams.wave_vec = [2 0] * 2;
        sysparams.rh_wave_vec = 1.7 * (2* pi/5);
        sysparams.rh_rot_angle = 0;
        
        
        
        %%Maakes the boundaries
        if(1)
            sysparams.landmark_cell_radius = landmark_cell_radius;            
            sysparams.bound_list = {};
            MakeSquareBoundaries
            %    MakeTrapezoidBoundaries
            GenerateSystem
            %    PopulateLandmarkCells
            landmark_cell_list = {};
            MakeCircularLandmarkCellsFromBoundaryList;
            %MakeUniBoundaryLandmarkCellsFromBoundaryList;
            
        else
            sysparams.landmark_cell_radius = landmark_cell_radius;
            sysparams.bound_list = {};
            MakeSquareBoundaries
            %    MakeTrapezoidBoundaries
            GenerateSystem
            %    PopulateLandmarkCells
            landmark_cell_list = {};
            MakeCircularLandmarkCellsFromBoundaryList;
            tmp_square_boundaries = sysparams.bound_list;
            %        sysparams.bound_list = {tmp_square_boundaries{1}, tmp_square_boundaries{2}};
            %MakeUniBoundaryLandmarkCellsFromBoundaryList;
            MakeCircularLandmarkCellsFromBoundaryList
            sysparams.bound_list = tmp_square_boundaries;
            
            
        end
        OutputLandmarkCellFiringFields
        Run2DAttractSysParams; %Most of the meat in here
    end
    
end

