
%sysparams.verbose.output_cond_dists  = (run_num == sysparams.n_runs);
%sysparams.verbose.output_cond_dists = 0;
if(sysparams.verbose.output_cond_dists)
    for cond_num = 1:sysparams.n_conds
        fprintf('Printing Image for cond %d \n', cond_num);
        cond_fir_image = FiringRateImage(system,  system.cond_z_accums(:, :, cond_num), system.cond_times_visited(:, :, cond_num));
        imwriteWithPath(cond_fir_image, sprintf('%s/ZFiring/StripeCells/Cond%dRun%d.png', sysparams.folder_path,  cond_num, run_num));
        cond_fir_clock_image = FiringRateClockImage(system,  system.cond_z_accums(:, :, cond_num), system.cond_times_visited(:, :, cond_num));
        imwriteWithPath(cond_fir_clock_image, sprintf('%s/ZFiring/Clock/ClockCond/Cond%dRun%d.png', sysparams.folder_path,  cond_num, run_num));
        imwriteWithPath(cond_fir_clock_image, sprintf('%s/ZFiring/Clock/ClockCondShuffle/Run%dCond%d.png', sysparams.folder_path,  run_num, cond_num));
        
    end
    
    cond_pair_list = {[1 2], [3 4], [5 6], [ 7 8]}
    
    for cond_pair_ind = 1:length(cond_pair_list)
        cur_cond_pair = cond_pair_list{cond_pair_ind};
        for i = 1:2
            cond_phases{i} =  system.cond_z_accums(:, :, cur_cond_pair(i))./system.cond_times_visited(:, :, cur_cond_pair(i));
        end
        cond_phase_ratios = cond_phases{1}./cond_phases{2};
        cond_phase_ratios(~isfinite(cond_phase_ratios)) = 0;
        cond_ratio_clock_image = FiringRateClockImage(system,  cond_phase_ratios.^10,  abs(cond_phase_ratios));
        imwriteWithPath(cond_ratio_clock_image, sprintf('%s/ZFiring/Clock/ClockCondCompare/Cond%dVs%dRun%d.png', sysparams.folder_path,  cur_cond_pair(1), cur_cond_pair(2), run_num));
        cond_phase_diffs = imag(log(cond_phase_ratios(:)));
        fprintf('Max, Min, Phase Diffs for pairs %d, %d, is (%f, %f) \n', cur_cond_pair(1), cur_cond_pair(2), max(cond_phase_diffs), min(cond_phase_diffs));
        
        %Plotting things like I plot the data
        if(run_num == sysparams.n_runs || true)
            for x_or_y = 1:2
                ok_mask = (system.z_forcing_array ==0) .* (system.in_bounds);
                close all;
                        
                for i = 1:2
                    zeroed_out_firing_rate{i} = real(cond_phases{i});                    
                    zeroed_out_firing_rate{i}(~ok_mask) = nan;
                    firing_rate_to_plot = nanmean(zeroed_out_firing_rate{i}, x_or_y);
                    firing_rate_to_plot(isnan(firing_rate_to_plot)) = -2;
                    plot(firing_rate_to_plot, '*-');
                    ylim([-2 1]);
                    xlim([0 length(firing_rate_to_plot)+1]);
                    hold on;                    
                end
                    output_file_path = sprintf('%s/ZFiring/CondCompare/XY%dCond%dVs%d(Run%d).png', sysparams.folder_path, x_or_y, cur_cond_pair(1), cur_cond_pair(2),  run_num);
                    MakeFilePath(output_file_path);
                    saveas(1, output_file_path)                
                close all
                
            end
        end
    end
    
    
    
end

for stripe_phase_shift = sysparams.stripe_phase_shifts
    %    output_image = FiringRateImage(system, system.z_accum_array *stripe_phase_shift  ,  system.times_visited_array);
    output_image = FiringRateImage(system, system.z_accum_array *stripe_phase_shift  ,  system.times_visited_array);
    
    imwriteWithPath(output_image, sprintf('%s/ZFiring/Raw/Phase%f/Run%d.png', sysparams.folder_path, imag(log(stripe_phase_shift)), run_num));
    output_image_cont = FiringRateContourImage(system, system.z_accum_array *stripe_phase_shift  ,  system.times_visited_array);
    %    output_image_cont = ImageCopyPaste(output_image_cont, isnan(output_image_cont(:, :, 1)), output_image);
    imwriteWithPath(output_image_cont, sprintf('%s/ZFiring/RawContour/Phase%f/Run%d.png', sysparams.folder_path, imag(log(stripe_phase_shift)), run_num));
    
    
end
output_clock_image = FiringRateClockImage(system, system.z_accum_array,  system.times_visited_array);
imwriteWithPath(output_clock_image, sprintf('%s/ZFiring/Clock/RawClock/Run%d.png', sysparams.folder_path, run_num));


