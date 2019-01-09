
CloseAllFigsAndWaitBars
StartOfSimulationGraphics


%% Main Loop

run_iters = 1:sysparams.n_runs;

if(0)
    learning_program.should_learn_list = run_iters< (sysparams.n_runs/2);
    learning_program.zero_to_one_after_learned = (run_iters - sysparams.n_runs/2.) /(sysparams.n_runs/2.);
    learning_program.wave_vec_gain = 2 * learning_program.zero_to_one_after_learned;
    learning_program.wave_vec_gain(learning_program.should_learn_list) = 1;    
elseif(0)
    learning_program.should_learn_list = run_iters< (sysparams.n_runs/2);
    learning_program.zero_to_one_after_learned = (run_iters - sysparams.n_runs/2.) /(sysparams.n_runs/2.);
    learning_program.wave_vec_gain = 2 * learning_program.zero_to_one_after_learned;
    learning_program.wave_vec_gain(learning_program.should_learn_list) = 1;       
    learning_program.wave_vec_gain(~learning_program.should_learn_list) = .5;           
    learning_program.should_learn_list = run_iters< (sysparams.n_runs * 2);
else
    %Learn instantly, slowly increase gain
    learning_program.should_learn_list = run_iters< 2;
    learning_program.zero_to_one_after_learned = (run_iters - 1) /(sysparams.n_runs -1);
    learning_program.wave_vec_gain = 1 + learning_program.zero_to_one_after_learned;
    learning_program.wave_vec_gain(learning_program.should_learn_list) = 1;                
end


learning_program.wave_vec_gain = 1 + .5 * (learning_program.wave_vec_gain -1)/sysparams.mouse_vel;
learning_program.wave_vec_gain = learning_program.wave_vec_gain * sysparams.base_gain;
stats.max_i_force = 0;
h_waitbar = waitbar(0, '');


for run_num = 1:sysparams.n_runs
    sysparams.wave_vec = [0 1] * learning_program.wave_vec_gain(run_num);
    cur_z = 1;
    cur_rh_vu = [0 0];
    
    tic;
    Generate1DSingleRunPath
    fprintf('Time To generate path = %f \n', toc);
    
    fprintf('Doing run %d \n', run_num);
    
    fprintf('Calculating path conditions \n' );
    tic
    CalculatePathConditions
    fprintf('Time To calculate conditions = %f \n', toc);
    
    
    
    
    
    
    
    tic;
    
    my_rand_array = randi(2, size(path.iX));
    
    fprintf('Starting run %d \n', run_num);
    for iT = 2:path.run_steps
        %% UPdates the position and the times visited arrays
        if(mod(iT, round(path.run_steps/100)) == 0)
            wait_bar_message = sprintf('%.3f done with LinTrackRun %d', iT * 1./path.run_steps, run_num);
            waitbar(iT * 1./path.run_steps, h_waitbar,  wait_bar_message)
        end
        
        cur_iX = path.iX(iT);
        cur_iY = path.iY(iT);
        
        
        
        
        %% Updates Current Z Value
        %Updates the current z value
        cur_z = cur_z * exp((path.delta_iY(iT) *sysparams.wave_vec(1) + path.delta_iX(iT) * sysparams.wave_vec(2)) * j * sysparams.spacing  );
        cur_forcing = path.dt * system.z_forcing_array(cur_iY, cur_iX);
        cur_z = cur_z + cur_forcing * sysparams.force_mult;
        cur_z = cur_z / abs(cur_z);
        
        %We update the times visited array, then do everything with either
        %the z or rH representation.
        
        
        
        
        
        %%Updates the Accum Arrays. I do this in a weird way. I think I
        %%dump things where the condition wasn't satisfied to a larger
        %%dimension.
        for cond_num = 1:length(path_condition_list)
            cond_to_fill = path_condition_list{cond_num}(iT);
            system.cond_z_accums(cur_iY, cur_iX, cond_to_fill) = system.cond_z_accums(cur_iY, cur_iX, cond_to_fill) + cur_z;
        end
        system.z_accum_array(cur_iY, cur_iX) = system.z_accum_array(cur_iY, cur_iX) + cur_z;
        
        
        
        
        %%Logs the path conditions
        system.times_visited_array(cur_iY, cur_iX) = system.times_visited_array(cur_iY, cur_iX) + 1;
        for cond_num = 1:sysparams.n_conds
            cond_to_fill = path_condition_list{cond_num}(iT);
            system.cond_times_visited(cur_iY, cur_iX, cond_to_fill) = system.cond_times_visited(cur_iY, cur_iX, cond_to_fill) + 1;
        end
    end
    fprintf('Finished simulating run %d \n', run_num);
    fprintf('Time to run path = %f \n', toc);
    phase_traversed_array{run_num} = PrettifiedPhaseFromZ(system.z_accum_array(system.in_bounds));
    mid_box_phase_traversed = prctile(phase_traversed_array{run_num} , 90) - prctile(phase_traversed_array{run_num} , 30);
    mid_box_width = prctile(system.mesh.x(system.in_bounds), 90) - prctile(system.mesh.x(system.in_bounds), 30);
    observed_gain(run_num) = mid_box_phase_traversed/mid_box_width;
    if(learning_program.should_learn_list(run_num))
        LandmarkCellLearning
    end
    OutputAllZFiringFields;
    
    if(1)
    close all;
    plot(system.mesh.x(system.in_bounds), PrettifiedPhaseFromZ(system.z_accum_array(system.in_bounds)));    
    ylim([0, sysparams.base_gain * 2 * max(system.mesh.x(:))]);
    output_path = sprintf('%s/PhiVsX/SpineRun%dMouseVel%f.png',sysparams.folder_path, run_num, sysparams.mouse_vel);
    hold on;
    base_phase_gain = sysparams.base_gain *(system.mesh.x(system.in_bounds) - min(system.mesh.x(system.in_bounds)));
    plot(system.mesh.x(system.in_bounds), base_phase_gain, '--k');
    title(sprintf('Vel %.4f, Mean diff is %.5f, max diff is %.5f', sysparams.mouse_vel, mean(PrettifiedPhaseFromZ(system.z_accum_array(system.in_bounds)) - base_phase_gain), max(PrettifiedPhaseFromZ(system.z_accum_array(system.in_bounds)) - base_phase_gain)   ));
    
        MakeFilePath(output_path);
    saveas(1, output_path);
    close all;
    end
    
    
    %EndOfIterationGraphics
    if(learning_program.should_learn_list(run_num))
        UpdateForcingArray
    end
    rezeroAccumArrays
    
end



EndOfSimulationGraphics
