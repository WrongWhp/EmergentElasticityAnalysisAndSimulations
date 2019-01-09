PlotPhaseSlices(system, system.z_accum_array);
MakeFilePath(sprintf('%s/ZFiring/ZPhaseSlices/ZPhaseSliceRun%d.png',sysparams.folder_path, run_num));


saveas(1, sprintf('%s/ZFiring/ZPhaseSlices/ZPhaseSliceRun%d.png',sysparams.folder_path, run_num));
saveas(1, sprintf('%s/ZFiring/ZPhaseSlices/ZPhaseSliceRun%d.fig',sysparams.folder_path, run_num));

if(sysparams.verbose.output_cond_dists)
    for cond_num = 1:sysparams.n_conds
        fprintf('Printing Slices for cond %d \n', cond_num);
        close all
        PlotPhaseSlices(system, system.cond_z_accums(:, :, cond_num));
        MakeFilePath(sprintf('%s/ZFiring/ZPhaseSlicesCond/ZPhaseSliceRun%dCond%d.fig',sysparams.folder_path, run_num, cond_num));
        saveas(1, sprintf('%s/ZFiring/ZPhaseSlicesCond/ZPhaseSliceRun%dCond%d.fig',sysparams.folder_path, run_num, cond_num));
        saveas(1, sprintf('%s/ZFiring/ZPhaseSlicesCond/ZPhaseSliceRun%dCond%d.png',sysparams.folder_path, run_num, cond_num));
        %    cond_fir_image = FiringRateImage(system,  system.cond_z_accums(:, :, cond_num), system.cond_times_visited(:, :, cond_num));
        %    imwriteWithPath(cond_fir_image, sprintf('%s/ZFiring/Cond%dUnblurredRun%d.png', sysparams.folder_path,  cond_num, run_num));
    end
end