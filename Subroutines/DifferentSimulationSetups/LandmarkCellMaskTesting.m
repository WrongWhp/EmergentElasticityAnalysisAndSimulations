

%for landmark_cell_radius = .5:.25:1.01
%    for cur_force_mult = .1:.2:.99;

for landmark_cell_radius = .6
    for cur_force_mult = 2 *  2 * .5 * 1 * 2 * .5 * (.25)
        for wall_force_mult = 1 * [2];
            for rh_wave_vec = (2* pi/5) * (1.2:.2:2.4)
                %Simple TEst
                %    for cur_force_mult = [.075 .1 .15 .4 .8]
                %Clear out old stuff that's not needed
                clear system
                clear path
                clear sysparams
                
                
                MakeSysParams %A lot of defaults are set by this.
                sysparams.sharp_landmark_masks = false;
                sysparams.graining = 2;
                sysparams.width = 12;
                sysparams.height = 12;
                %    sysparams.rh_graining = 19;
                sysparams.rh_graining = 15;
                
                sysparams.n_runs = 10;
                sysparams.steps_per_pixel = 120; %Average number of times the mouse will step foot in each pixel
                sysparams.force_mult = cur_force_mult;
                sysparams.folder_path = sprintf('../Outputs/MaskTesting/Graining%d/Radius%f/Wavevec%f/ArchOutputStrength%f/WallMult%f/',  sysparams.graining, landmark_cell_radius, rh_wave_vec,  cur_force_mult, wall_force_mult);
                
                sysparams.verbose.output_landmark_fields = false;
                sysparams.verbose.output_landmark_states = false;
                sysparams.verbose.output_system_states = false;
                sysparams.verbose.output_rh_dists= false;
                sysparams.verbose.output_cond_dists = false;
                MakeSysParamsHelpers %The sysparams struct has some redundant information which is created here
                
                
                sysparams.wave_vec = [2 0] * 2;
                %            sysparams.rh_wave_vec = 1.7 * (2* pi/5);
                sysparams.rh_wave_vec = rh_wave_vec;
                
                sysparams.rh_rot_angle = .0;
                sysparams.ellipse_asp_ratio = 3;
                
                
                
                %%Maakes the boundaries
                if(1)
                    sysparams.landmark_cell_radius = landmark_cell_radius;
                    sysparams.bound_list = {};
                    MakeSquareBoundaries
                    %    MakeTrapezoidBoundaries
                    GenerateSystem
                    %    PopulateLandmarkCells
                    landmark_cell_list = {};
                    if(1)
                        MakeExpBoundaryLandmarkCellsFromBoundaryList;
                        
%                        MakeUniBoundaryLandmarkCellsFromBoundaryList;
                        for i = 1:length(landmark_cell_list)
                            cur_landmark_cell = landmark_cell_list{i};
                            cur_landmark_cell.strength = cur_landmark_cell.strength*wall_force_mult;
                            landmark_cell_list{i}= cur_landmark_cell;
                        end
                    end
 %                   MakeRectangularCellsFromBoundaryList
                    MakeEllipticalLandmarkCellsFromBoundaryList;
                    
                    %                MakeCircularLandmarkCellsFromBoundaryList;
                    %                MakeUniBoundaryLandmarkCellsFromBoundaryList;
                    
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
                
                
                [wall_local_weighting, total_strength] = WallLocalWeighting(sysparams, system, landmark_cell_list)

                OutputLandmarkCellFiringFields
                
                
                Run2DAttractSysParams; %Most of the meat in here
                OutputCenterOfBoxCondRH    
                y_wall_v_shift_this_run =   (mod( (cond_center_of_box_vu(:, [5], 1) - cond_center_of_box_vu(:, [6], 1))* 2 * pi+ 3* pi, 2*pi)-pi);
                y_wall_u_shift_this_run =  (mod( (cond_center_of_box_vu(:, [5], 2) - cond_center_of_box_vu(:, [6], 2))* 2 * pi+ 3* pi, 2*pi)-pi);
                y_wall_y_shift_this_run = vu2yx(y_wall_v_shift_this_run/sysparams.rh_wave_vec, y_wall_u_shift_this_run/sysparams.rh_wave_vec);

                x_wall_v_shift_this_run = (mod( (cond_center_of_box_vu(:, [7], 1) - cond_center_of_box_vu(:, [8], 1))* 2 * pi+ 3* pi, 2*pi)-pi);                
                x_wall_u_shift_this_run = (mod( (cond_center_of_box_vu(:, [7], 2) - cond_center_of_box_vu(:, [8], 2))* 2 * pi+ 3* pi, 2*pi)-pi);
                [~, x_wall_x_shift_this_run] = vu2yx(x_wall_v_shift_this_run/sysparams.rh_wave_vec, x_wall_u_shift_this_run/sysparams.rh_wave_vec);
                
                close all
                plot(x_wall_x_shift_this_run); 
                hold on;
                plot(y_wall_y_shift_this_run)                
%                pause;
                saveas(1, sprintf('%s/ShiftOverEpoch.png', sysparams.folder_path));
                
%                v_shift_this_run = (cond_center_of_box_vu(:, [7], 1) - cond_center_of_box_vu(:, [8], 1))* 2 * pi/(sysparams.rh_wave_vec)


            end
        end
    end
end
