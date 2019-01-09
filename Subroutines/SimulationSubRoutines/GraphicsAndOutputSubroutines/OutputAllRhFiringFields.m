
vu_shifts = {[0 0], [.5 0], [0 .5]};
output_rh_image = FiringRateImageFromRhDist(system, system.rh_accum_array, system.times_visited_array, vu_shifts);
imwriteWithPath(output_rh_image, sprintf('%s/Rh/RHUnblurredRun%d.png',sysparams.folder_path, run_num));

output_grid_image = FiringRateImageFromRhDistFancyVisualizationMask(system, system.rh_accum_array, system.times_visited_array, GridVisualizationRhDist(sysparams.rh_graining));
imwriteWithPath(output_grid_image, sprintf('%s/Rh/Gridlines/Hex/RHUnblurredRun%d.png',sysparams.folder_path, run_num));

output_grid_image = FiringRateImageFromRhDistFancyVisualizationMask(system, system.rh_accum_array, system.times_visited_array, GridVisualizationRhDistSquare(sysparams.rh_graining));
imwriteWithPath(output_grid_image, sprintf('%s/Rh/Gridlines/Square/RHUnblurredRun%d.png',sysparams.folder_path, run_num));

for graph_v_shift = sysparams.rh_v_shift_list;
    for graph_u_shift = sysparams.rh_u_shift_list;
        cur_vu_shift = { [graph_v_shift graph_u_shift], [graph_v_shift graph_u_shift], [graph_v_shift graph_u_shift]};
%        output_rh_image = FiringRateImageFromRhDist(system, system.rh_accum_array, system.times_visited_array, cur_vu_shift);
        output_rh_image = FiringRateImageFromRhDistColorScheme(system, system.rh_accum_array, system.times_visited_array, cur_vu_shift);
        imwriteWithPath(output_rh_image, sprintf('%s/Rh/Shifted/graph_v%fgraph_u%fRHUnblurredRun%d.png',sysparams.folder_path,graph_v_shift, graph_u_shift, run_num));
        
    end
end






for cond_num = 1:sysparams.n_conds
    fprintf('Printing Image for cond %d \n', cond_num);
    cond_fir_image = FiringRateImageFromRhDist(system,  system.cond_rh_accum(:, :, :, :,  cond_num), system.cond_times_visited(:, :, cond_num), vu_shifts);
    imwriteWithPath(cond_fir_image, sprintf('%s/Rh/RHCond/RHCond_Run%dCond%d.png', sysparams.folder_path,  run_num, cond_num));

    cond_fir_image = FiringRateImageFromRhDistColorScheme(system,  system.cond_rh_accum(:, :, :, :,  cond_num), system.cond_times_visited(:, :, cond_num), vu_shifts);

    imwriteWithPath(cond_fir_image, sprintf('%s/Rh/RHCondJet/RHCond_Run%dCond%d.png', sysparams.folder_path,  run_num, cond_num));
    
end

if(0)
    for graph_v_shift = sysparams.rh_v_shift_list
        for graph_u_shift = sysparams.rh_u_shift_list
            
            for cond_num = 1:sysparams.n_conds
                fprintf('Printing Image for cond %d \n', cond_num);
                cur_vu_shift = { [graph_v_shift graph_u_shift], [graph_v_shift graph_u_shift], [graph_v_shift graph_u_shift]};
                %        output_rh_image = FiringRateImageFromRhDist(system, system.rh_accum_array, system.times_visited_array, cur_vu_shift);
                 cond_fir_image = FiringRateImageFromRhDistColorScheme(system,  system.cond_rh_accum(:, :, :, :,  cond_num), system.cond_times_visited(:, :, cond_num), cur_vu_shift);
                imwriteWithPath(cond_fir_image, sprintf('%s/Rh/ShiftedWithColor/graph_v%fgraph_u%fCond%dRHUnblurredRun%d.png',sysparams.folder_path,graph_v_shift, graph_u_shift, cond_num,  run_num));
                
            end
            
            
        end
    end
end