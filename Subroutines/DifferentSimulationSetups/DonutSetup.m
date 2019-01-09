%[.005 .01 .05 .2 .5 1 2]

%for cur_force_mult = [.4 .6 .8 1.5 ]
for cur_force_mult = [1 1.5 2 3]
    
    for curl = [0  1]
        %    for cur_force_mult = [.075 .1 .15 .4 .8]
        %Clear out old stuff that's not needed
        clear system
        clear path
        clear sysparams
        
        
        MakeSysParams %A lot of defaults are set by this.
        sysparams.graining = 6;
        sysparams.width = 14;
        sysparams.height = 8;
        sysparams.rh_graining = 15;
        sysparams.n_runs = 20;
        sysparams.steps_per_pixel = .3 * 300; %Average number of times the mouse will step foot in each pixel
        sysparams.force_mult = cur_force_mult;
        sysparams.sharp_landmark_masks = 0;
        
        
        
        sysparams.verbose.output_landmark_fields = true;
        sysparams.verbose.output_system_states = true;
        sysparams.verbose.output_rh_dists= false;
        sysparams.verbose.output_cond_dists = false;
        sysparams.landmark_cell_radius = .5
        
        MakeSysParamsHelpers %The sysparams struct has some redundant information which is created here
        
        %wave_vector = [1 3^.5];
        %wave_vector = [1 3^.5] * 2;
        sysparams.wave_vec = [0 1] * 2 * 1;
        %        sysparams.wave_vec = [0 1] * 2;
        sysparams.rh_wave_vec = (2 * pi * 1/3); %30 cm spacing in the base frame of 1LU = 10 cm, but I've scaled things up in the paper
        %2.4 * .8;
        sysparams.rh_rot_angle = .0;
        sysparams.folder_path = sprintf('../Outputs/DonutRectFebMoreRuns/StrengthVar/Graining%d/WaveVec%f/ArchOutputStrength%f/Curl%d/', sysparams.graining, sysparams.rh_wave_vec , cur_force_mult, curl);
        
        
        sysparams.bound_list = {};
        sysparams.rh_u_shift_list = 0:1:.99
        sysparams.rh_v_shift_list = 0:1:.99
        
        MakeRectDonutBoundaries;
        %        MakeSquareBoundaries
        %        sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(3, 7, 3, 7);
        %        sysparams.bound_list{length(sysparams.bound_list) + 1} = MakeInteriorRectangleBoundaryObject(3.6, 6.4, 3.6, 6.4);
        
        
        
        GenerateSystem
        landmark_cell_list = {}
        %    MakeUniBoundaryLandmarkCellsFromBoundaryList
        %        MakeCircularLandmarkCellsFromBoundaryList;
        
        MakeUniformCircularLandmarkCells;
        %       OutputLandmarkCellFiringFields
        
        
        
        if(curl)
            for i =  1:length(landmark_cell_list)
                cur_landmark_cell = landmark_cell_list{i};
                system_com = SystemCOM(system);
                [rotational_phase_list(i), ~] = cart2pol(cur_landmark_cell.y_center - system_com.y, cur_landmark_cell.x_center- system_com.x);
            end
            
            
            rotational_phase_list(rotational_phase_list<0) = rotational_phase_list(rotational_phase_list<0) + 2*pi;
            [~, sort_order] = sort(rotational_phase_list);
            rotational_phase_percentile = sort_order*0;
            rotational_phase_percentile(sort_order) = 2*pi * ((1:length(sort_order))/length(sort_order));
            
            
            rotational_phase_percentile = rotational_phase_percentile * 2;
            for i = 1:length(landmark_cell_list)
                
                cur_landmark_cell = landmark_cell_list{i};
                
                base_phase = cur_landmark_cell.y_center * sysparams.wave_vec(1) + cur_landmark_cell.x_center * sysparams.wave_vec(2);
                cur_landmark_cell.learned_z = exp(j * (base_phase + rotational_phase_percentile(i)*1));
                
                base_vu = sysparams.rh_wave_vec * [cur_landmark_cell.y_center cur_landmark_cell.x_center]/(2*pi);
                new_vu = base_vu  + ([0 1] * rotational_phase_percentile(i))/(2* pi);
                new_vu = mod(new_vu, 1);
                cur_landmark_cell.rh_dist_array = RhVUToDistArray(new_vu,  sysparams.rh_graining);
                [cur_landmark_cell.rh_V_forcing, cur_landmark_cell.rh_U_forcing] = ForceArrayFromRhDist(cur_landmark_cell.rh_dist_array);
                
                landmark_cell_list{i} = cur_landmark_cell;
            end
        end
        UpdateForcingArray
        Run2DAttractSysParams; %Most of the meat in here
        sysparams.rh_u_shift_list = 0:.25:.99
        sysparams.rh_v_shift_list = 0:.25:.99
        
        Run2DAttractSysParamsOneLastRunForResolution
    end
end
