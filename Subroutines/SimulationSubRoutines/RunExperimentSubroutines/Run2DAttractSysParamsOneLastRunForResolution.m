%Most of the meat is in here. This actually runs the simulation for a set
%of system parameters.
CloseAllFigsAndWaitBars
%StartOfSimulationGraphics


%% Main Loop


stats.max_i_force = 0;
h_waitbar = waitbar(0, '');

for run_num = sysparams.n_runs + 1 %Number of learning epochs

    %% Initializes the postiion self-estimates of the mouse. There are three
    %"position self-estimates" of the mouse. 
    %1) An actual position self-estimate. 2) A ring attractor state 3) A 2d attractor state
    

   
    cur_z = 1;
    cur_rh_vu = .5 + [0 0];    
    
    
    %%Calculates the path
    tic;
    GenerateRandomWalkPath
    cur_est_xy = [system.x_array(path.iX(1)), system.y_array(path.iY(1))];%Initialize the estiamte of X Y to the actual value
    
    fprintf('Time To generate path = %f \n', toc);    
    fprintf('Doing run %d \n', run_num);    
    fprintf('Calculating path conditions \n' );
    tic
    CalculatePathConditions %Will be used for path-conditioned rate maps
    fprintf('Time To calculate conditions = %f \n', toc);    
    

    tic;
    path_log.xy_vs_time(1, :) = cur_est_xy;
    path_log.uv_vs_time(1, :) = fliplr(cur_rh_vu);
    
    
    fprintf('Starting run %d \n', run_num);
    for iT = 2:path.run_steps
        %% Updates the waitbar
        if(mod(iT, round(path.run_steps/100)) == 0)
            wait_bar_message = sprintf('%.3f done with run %d/%d of \n %s', iT * 1./path.run_steps, run_num, sysparams.n_runs, sysparams.folder_path);
            %            waitbar(iT * 1./path.run_steps, h_waitbar,  wait_bar_message)
            waitbar(iT * 1./path.run_steps, h_waitbar , wait_bar_message)
        end
        
        %Updates the positio of the mouse. %iX, iY are integers(lattice
        %corrdinates). 
        cur_iX = path.iX(iT);
        cur_iY = path.iY(iT);
        
        
        %%Updates the current XY Estimate
        cur_est_xy = cur_est_xy + sysparams.spacing * [path.delta_iX(iT) path.delta_iY(iT)]; %Path integration
        cur_xy_forcing = reshape(system.est_xy_forcing_array(cur_iY, cur_iX, :), [1 2]);
        cur_xy_forcing_strength = system.est_xy_forcing_strength(cur_iY, cur_iX);
        cur_xy_force = (cur_xy_forcing - cur_est_xy)*cur_xy_forcing_strength;
        cur_est_xy = cur_est_xy + cur_xy_force*path.dt * sysparams.force_mult;
        %        cur_est_xy = (cur_est_xy + cur_xy_forcing_strength * cur_xy_forcing * path.dt * sysparams.force_mult)/(1 + cur_xy_forcing_strength * path.dt*sysparams.force_mult);%        %Landmark Forcing
        est_xy_list(iT, :) = cur_est_xy;
        
        %% Updates Current Z Value
        %Updates the current z value
        cur_z = cur_z * exp((path.delta_iY(iT) *sysparams.wave_vec(1) + path.delta_iX(iT) * sysparams.wave_vec(2)) * j * sysparams.spacing  ); %Path integration
        cur_z_forcing = path.dt * system.z_forcing_array(cur_iY, cur_iX);
        cur_z = cur_z + cur_z_forcing * sysparams.force_mult;
        cur_z = cur_z / abs(cur_z);
        
        %We update the times visited array, then do everything with either
        %the z or rH representation.
        
        
        
        %% Updates Current Rhombus Positiom. We delta_iV,         
        rotated_delta_iY = cos(sysparams.rh_rot_angle) * path.delta_iY(iT) + sin(sysparams.rh_rot_angle) * path.delta_iX(iT);
        rotated_delta_iX = -sin(sysparams.rh_rot_angle) * path.delta_iY(iT) + cos(sysparams.rh_rot_angle) * path.delta_iX(iT);
        
        [delt_V_posit_lattice_coords, delt_U_posit_lattice_coords] = yx2vu(rotated_delta_iY, rotated_delta_iX); 
        cur_rh_vu = cur_rh_vu + sysparams.rh_wave_vec * (sysparams.spacing/(2* pi)) * [delt_V_posit_lattice_coords delt_U_posit_lattice_coords]; 
        %Convert from position lattice coordinates to twisted-torus
        %coordinates. 
        cur_rh_vu = mod(cur_rh_vu, 1); %We define U, V modulo 1 in the code, rather than modulo 2pi.

        %Each landmark cell is modeled as a *distribution* over the twisted torus. We need the function RhToDist to to convert a single point to an (aliased) one-hot distribution        
        cur_rh_dist_struct = RhVUToDistObj(cur_rh_vu, sysparams.rh_graining);
        permuted_weight_array = permute(cur_rh_dist_struct.weight_array, [3 4 1 2]);
        
        %Calculate the force from the landmark cells onto the attractor
        %network. system.rh_V_forcing_array, system.rh_U_forcing_array are functions of both real and attractor states, representing the *combined* landmark forces acting at a particular location
        
        local_V_force = system.rh_V_forcing_array(cur_iY, cur_iX, cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range);
        cur_V_force = sum(local_V_force(:) .* permuted_weight_array(:));       
        local_U_force = system.rh_U_forcing_array(cur_iY, cur_iX, cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range);
        cur_U_force = sum(local_U_force(:) .* permuted_weight_array(:));
        cur_rh_vu = mod(cur_rh_vu + [cur_V_force cur_U_force] * path.dt * sysparams.force_mult, 1);
        
        
        %% Log the forces vs time. 
        path_log.xy_force_vs_time(iT, :)  = cur_xy_force;
        path_log.uv_force_vs_time(iT, :)  = [cur_U_force cur_V_force];
        path_log.xy_vs_time(iT, :) = cur_est_xy;
        path_log.uv_vs_time(iT, :) = fliplr(cur_rh_vu);

        %% Updates the Accum Arrays. There are the non-path-conditioned arrays which will be used to evaluate the learning of each landmark cell. 
        %There are also the path-conditioned arrays which will be used to
        %construct path-conditioned maps. I update path-conditioned arrays
        %in a weird way to prevent the use of if statements. There are 8
        %path conditions I compute, but each path conditined array has room
        %for 9 conditions. For each condition, if the condition is
        %satisfied, I increment the appropriate place in the array. If the
        %condition is not satisfied, I increment the "9th" condition, which is never used.  

        system.est_xy_accum_array(cur_iY, cur_iX, :) = system.est_xy_accum_array(cur_iY, cur_iX, :)  + reshape(cur_est_xy, [1 1 2]);
        system.z_accum_array(cur_iY, cur_iX) = system.z_accum_array(cur_iY, cur_iX) + cur_z;        
        
        for cond_num = 1:sysparams.n_conds
            cond_to_fill = path_condition_list{cond_num}(iT); %Either the appropriate condition, or 9(condition not met)
            system.cond_z_accums(cur_iY, cur_iX, cond_to_fill) = system.cond_z_accums(cur_iY, cur_iX, cond_to_fill) + cur_z;
            system.cond_est_xy_accum_array(cur_iY, cur_iX, cond_to_fill, :) = system.cond_est_xy_accum_array(cur_iY, cur_iX, cond_to_fill, :)  + reshape(cur_est_xy, [1 1 1 2]);
        end
        
        
        system.rh_accum_array(cur_iY, cur_iX,   cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range) =...
            system.rh_accum_array(cur_iY, cur_iX,  cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range) + permuted_weight_array;
        
        for cond_num = 1:sysparams.n_conds
            cond_to_fill = path_condition_list{cond_num}(iT);
            system.cond_rh_accum(cur_iY, cur_iX,   cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range, cond_to_fill) =  ...
                system.cond_rh_accum(cur_iY, cur_iX,  cur_rh_dist_struct.iV_range, cur_rh_dist_struct.iU_range, cond_to_fill) ...
                + permuted_weight_array;
            %            system.cond_rh_accum(cur_iY, cur_iX, cond_to_fill) = system.cond_z_accums(cur_iY, cur_iX, cond_to_fill) + cur_z;
        end
        
        
        
        % Logs the times visited, which will be used to normalize the other arrays
        system.times_visited_array(cur_iY, cur_iX) = system.times_visited_array(cur_iY, cur_iX) + 1;
        for cond_num = 1:sysparams.n_conds
            cond_to_fill = path_condition_list{cond_num}(iT);
            system.cond_times_visited(cur_iY, cur_iX, cond_to_fill) = system.cond_times_visited(cur_iY, cur_iX, cond_to_fill) + 1;
        end
    end
    
            LandmarkCellLearning; %Updates the states of landmark cells based on the statistics of the animal's position self-estimates.

    if(1)
        if(run_num == sysparams.n_runs)
%            outputRhDistsOfBorderPositions
        end
        
        fprintf('Finished simulating run %d \n', run_num);
        fprintf('Time to run path = %f \n', toc);
        
        fprintf('Force ratio mean is %f \n', nanmean(path_log.uv_force_vs_time(:)./path_log.xy_force_vs_time(:)));
        fprintf('Force  ratio std is %.8f \n', nanstd(path_log.uv_force_vs_time(:)./path_log.xy_force_vs_time(:)));
        EstXYSandBox
%        OutputLandmarkCellRhDists;
        OutputAllRhFiringFields
%        OutputCenterOfBoxCondRH     
        OutputAllZFiringFields;
        LogCenterOfBoxCondRH
        OutputSystemState
        GraphEstXY
        GraphRHEstXYMesh
        
        if(false || run_num == sysparams.n_runs || run_num == 1)
         %  OutputLandmarkCellRhDists 
        end
    else
     %   EndOfIterationGraphics
        GraphEstXY
        
    end
    
    UpdateForcingArray %Goes from the state of each indiviual landmark cell to the effect of all *combined* landmarks on the attractor network as a function of position. 
    rezeroAccumArrays %Resets the statistics for the next learning epoch
end


%EndOfSimulationGraphics
