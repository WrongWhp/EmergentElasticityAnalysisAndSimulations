%for wall_force_mult = 5:5:20

for cur_force_mult = .5 *  2 * [1.5 1 4];
    for wall_force_mult = 2 * [.5] * 1;
        for rh_wave_vec =  2* pi/3 * (1.0:.2:2);
            %    for cur_force_mult = .5 * [.5:.5:2];
            %Simple TEst
            %    for cur_force_mult = [.075 .1 .15 .4 .8]
            %Clear out old stuff that's not needed
            clear system
            clear path
            clear sysparams
            %        sysparams.landmark_cell_radius = .15;
            
            
            MakeSysParams %A lot of defaults are set by this.
            sysparams.graining = 5;
            sysparams.sharp_landmark_masks = false;
            sysparams.width = 10;
            sysparams.height = 10;
            sysparams.rh_graining = 11;
            %    sysparams.rh_graining = 9;
            
            sysparams.n_runs = 15;
            sysparams.rh_v_shift_list = 0:.2:.8;
            sysparams.rh_u_shift_list = 0:.33:.1;
            sysparams.ellipse_asp_ratio = 3;
            
            sysparams.steps_per_pixel = 150; %Average number of times the mouse will step foot in each pixel
            sysparams.force_mult = cur_force_mult;
            sysparams.folder_path = sprintf('../Outputs/Trapezoid724Aug/StrengthVar/Graining%d/Wavevec%f/ArchOutputStrength%f/WallMult%f/SharpFields%d/', sysparams.graining, rh_wave_vec, cur_force_mult, wall_force_mult, sysparams.sharp_landmark_masks);
            
            sysparams.verbose.output_landmark_fields = false;
            sysparams.verbose.output_landmark_states = false;
            sysparams.verbose.output_system_states = false;
            sysparams.verbose.output_rh_dists= false;
            sysparams.verbose.output_cond_dists = false;
            MakeSysParamsHelpers %The sysparams struct has some redundant information which is created here
            
            
            sysparams.wave_vec = [1 0] * 2;
            sysparams.rh_wave_vec = rh_wave_vec;
            sysparams.rh_rot_angle = 7 * pi/(180) * 0;
            sysparams.landmark_cell_radius = .16 * ( 8/5);
            
            
            
            %%Maakes the boundaries
            sysparams.bound_list = {};
            %    MakeSquareBoundaries
            MakeTrapezoidBoundaries
            GenerateSystem
            %    PopulateLandmarkCells
            landmark_cell_list = {};
            if(1)
                MakeExpBoundaryLandmarkCellsFromBoundaryList
            %        MakeUniBoundaryLandmarkCellsFromBoundaryList;
                for i = 1:length(landmark_cell_list)
                    cur_landmark_cell = landmark_cell_list{i};
                    cur_landmark_cell.strength = cur_landmark_cell.strength*wall_force_mult;
                    if(i == 5)
                        cur_landmark_cell.strength = cur_landmark_cell.strength * 1;
                    end
                    
                    landmark_cell_list{i}= cur_landmark_cell;
                end
            end
            MakeEllipticalLandmarkCellsFromBoundaryList
%            MakeRectangularCellsFromBoundaryList;
            
            %        MakeCircularLandmarkCellsFromBoundaryList;
            [wall_loc_weighting, tot_strength] = WallLocalWeighting(sysparams, system, landmark_cell_list)
            OutputLandmarkCellFiringFields
            Run2DAttractSysParams; %Most of the meat in here
        end
    end
end

