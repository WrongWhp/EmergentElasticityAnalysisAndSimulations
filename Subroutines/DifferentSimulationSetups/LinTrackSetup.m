%LINEAR TRACK STUFF
malcolm_landmark_strength_struct = open('Malcolm_Omega.mat');
omega = malcolm_landmark_strength_struct.omega;
omega = omega/mean(omega(:));
for cur_force_mult = [.12:.02:.28 .01 .02 .05 .1 .3  .5 1 2 .0] * 1
    for mouse_vel = [.5 1.5]
        %Clear out old stuff that's not needed
        clear system
        clear path
        clear sysparams
        
        
        MakeSysParams %A lot of defaults are set by this.
        %%Most paramters to change are here
        sysparams.mouse_vel = mouse_vel;
        sysparams.graining = 1;
        sysparams.width = 202;
        sysparams.use_sharp_mask = true;
        sysparams.tower_spacing = 1;
        sysparams.tower_width = 1;
        sysparams.force_mult = cur_force_mult;
        sysparams.base_gain = .12; %Width of 50
        sysparams.folder_path = sprintf('../Outputs/LinTrack/StrengthVar/ArchOutputStrength%f/MouseVel%f/', cur_force_mult, mouse_vel);
        %%
        
        
        sysparams.height = 3/sysparams.graining; %The box should be three pixels tall
        
        
        sysparams.rh_graining = 2;
        sysparams.n_runs = 20   ;
        sysparams.steps_per_pixel = 20; %Average number of times the mouse will step foot in each pixel(Not used for all things)
        sysparams.run_type = 'LinearTrack';
        
        
        
        sysparams.verbose.output_landmark_fields = false;
        sysparams.verbose.output_system_states = true;
        sysparams.verbose.output_rh_dists= false;
        
        MakeSysParamsHelpers %The sysparams struct has some redundant information which is created here
        
        sysparams.wave_vec = [0 1] * 2; %This currently is overridden in the LinTrackRun Routine
        sysparams.rh_wave_vec = 1 * 2;
        sysparams.rh_rot_angle = .1;
        
        
        
        sysparams.bound_list = {};
        MakeLinearTrackBoundaries
        
        GenerateSystem
        
        landmark_cell_list = {}
        %    MakeCircularLandmarkCellsFromBoundaryList;
        MakeTowerLandmarkCells
        for i = 1:length(landmark_cell_list)
            cur_landmark_cell = landmark_cell_list{i};
            cur_landmark_cell.strength = cur_landmark_cell.strength * omega(i);
            %(1 + .0 * sin(cur_landmark_cell.tower_ind/4));
            landmark_cell_list{i} = cur_landmark_cell;
        end
        
        
        %    PopulateLandmarkCells
        
        fprintf('Doing LinTrackRun \n');
        LinTrackRun    %Most of the meat is in here
        CloseAllFigsAndWaitBars
        plot(learning_program.wave_vec_gain(~learning_program.should_learn_list),  observed_gain(~learning_program.should_learn_list), 'LineStyle', '--', 'Marker', 'X');
        xlabel('Path integration gain');
        ylabel('Observed gain');
        saveas(1, sprintf('%s/ForceMult%f.png', sysparams.folder_path, cur_force_mult)  );
    end
    
end