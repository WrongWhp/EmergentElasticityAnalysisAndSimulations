
GenerateRandomWalkPath%This is just a trick to 

sparsify_param = 2;
if(sparsify_param ==1)
    
    mesh_line_width = 1.5;
    
    
    
    
    rh_est_vu_array = nan*system.est_xy_accum_array;
    
    
    
    %First populate the array
    for iY = system.iY_array
        for iX = system.iX_array
            if(system.in_bounds(iY, iX))
                %          fprintf('Here! \n');
                %         system.rh_est_u_
                cur_pixel_rh_dist = system.rh_accum_array(iY, iX, :, :);
                cur_pixel_permuted_cond_dist = permute(cur_pixel_rh_dist, [3 4 1 2]);
                
                rh_est_vu_array(iY, iX, :)  = RhDistArray2VU(cur_pixel_permuted_cond_dist, size(cur_pixel_permuted_cond_dist, 1));
            end
        end
    end
    
    
    %Next de_modulo it
    
    
    rh_prettified_est_vu_array = rh_est_vu_array;
    rh_prettified_times_visited_mask = 0 * system.mesh.x;
    
    %We need to traverse the envrionment to get a consistent set of u,vs which
    %are de-modulo-ed. The way we do it now is just take the path of the animal
    %itself. It's a bit inefficient and hacky, but it should work.
    cur_vu_reference_point = rh_est_vu_array(path.iY(1), path.iX(1), :);
    
    
    
    iT = 1;
    
    while(sum(rh_prettified_times_visited_mask(:)) < sum(system.times_visited_array(:)>0))
        iY = path.iY(iT);
        iX = path.iX(iT);
        cur_vu_point = rh_est_vu_array(iY, iX, :); %The un-modulo-ed new point
        cur_vu_reference_point = mod(cur_vu_point - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point); %Scale the unmodulo-ed point to the previous point
        
        rh_prettified_est_vu_array(iY, iX, :) =cur_vu_reference_point;
        rh_prettified_times_visited_mask(iY, iX) = 1;
        
        iT = iT + 1;
    end
    
    
    
    
    
    close all;
    
    [rh_est_y_mesh,  rh_est_x_mesh] = vu2yx(rh_prettified_est_vu_array(:, :, 1) * (2*pi/sysparams.rh_wave_vec), rh_prettified_est_vu_array(:, :, 2)* (2*pi/sysparams.rh_wave_vec));
    
    
    %m = mesh(rh_prettified_est_vu_array(:, :, 2), rh_prettified_est_vu_array(:, :, 1),  1.1  + 0*system.times_visited_array, 'LineWidth', mesh_line_width);
    view(gca,[0.0 0.0 90]);
    
    
    
    
    %Rotate by the original rotation angle. This way, withou any distortions we
    %have the same pattern
    de_rotation_angle = sysparams.rh_rot_angle * 0;
    
    
    rot_rh_est_x_mesh = cos(de_rotation_angle)* rh_est_x_mesh + sin(de_rotation_angle)* rh_est_y_mesh;
    rot_rh_est_y_mesh = -sin(de_rotation_angle)* rh_est_x_mesh+ cos(de_rotation_angle)* rh_est_y_mesh;
    
    
    rot_rh_est_x_mesh = rot_rh_est_x_mesh - nanmean(rot_rh_est_x_mesh(:));
    rot_rh_est_y_mesh = rot_rh_est_y_mesh - nanmean(rot_rh_est_y_mesh(:));
    %mesh_
    
    
    %The negative is to line up with other output images
    m = mesh(rot_rh_est_x_mesh, -rot_rh_est_y_mesh,  1.1  + 0*system.times_visited_array, 'LineWidth', mesh_line_width);
    set(m, 'EdgeColor', 'k');
    
    
    
    view(gca,[0.0 0.0 90]);
    daspect([1 1 1])
    min_x_in_box = min(system.mesh.x(system.in_bounds));
    min_y_in_box = min(system.mesh.y(system.in_bounds));
    
    max_x_in_box = max(system.mesh.x(system.in_bounds));
    max_y_in_box = max(system.mesh.y(system.in_bounds));
    
    x_lim = .75 *  (max_x_in_box - min_x_in_box) * [-1 1];
    y_lim = .75 *  (max_y_in_box - min_y_in_box) *[-1 1];
    
    
    xlim(x_lim);
    ylim(y_lim);
    
    
    set(gca, 'XTick', x_lim);
    set(gca, 'YTick', y_lim);
    
    
    %set(gca, 'XTick', x_lim * 1.5);
    %set(gca, 'YTick', y_lim* 1.5);
    
    %set(gca, 'XTick', x_lim * 1.5);
    %set(gca, 'YTick', y_lim* 1.5);
    
    
    fprintf('Max, min x is %f, %f \n', max(rh_est_x_mesh(:)), min(max(rh_est_x_mesh(:))));
    fprintf('Max, min y is %f, %f \n', max(rh_est_y_mesh(:)), min(max(rh_est_y_mesh(:))));
    
    output_png_file_path = sprintf('%s/RHXYMeshes/RHXYRun%d.png', sysparams.folder_path, run_num);
    output_fig_file_path = sprintf('%s/RHXYMeshes/FIGRHXYRun%d.fig', sysparams.folder_path, run_num);
    
    
    MakeFilePath(output_png_file_path);
    saveas(1, output_png_file_path);
    saveas(1, output_fig_file_path);
    
    %%%DONT need for now
    if(0)
        for iY = system.iY_array
            for iX = system.iX_array
                if(system.in_bounds(iY, iX))
                    
                    if(1)
                        if(system.in_bounds(iY-1, iX))
                            cur_vu_reference_point = rh_prettified_est_vu_array(iY-1, iX, :);
                            cur_vu_point = rh_est_vu_array(iY, iX, :);
                            rh_prettified_est_vu_array(iY, iX, :) =   mod(cur_vu_point - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point);
                        elseif (system.in_bounds(iY, iX-1))
                            cur_vu_reference_point = rh_prettified_est_vu_array(iY, iX-1, :);
                            cur_vu_point = rh_est_vu_array(iY, iX, :);
                            rh_prettified_est_vu_array(iY, iX, :) =   mod(cur_vu_point - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point);
                        else
                            cur_vu_reference_point  = nan * [1 1];
                            cur_vu_point = rh_est_vu_array(iY, iX, :);
                            rh_prettified_est_vu_array(iY, iX, :) =   rh_est_vu_array(iY, iX, :);
                        end
                        
                        scaled_vu_point = rh_prettified_est_vu_array(iY, iX, :);
                        
                        fprintf('Ref point is (%f,%f) \n', cur_vu_reference_point(1), cur_vu_reference_point(2));
                        fprintf('New point is (%f,%f) \n', cur_vu_point(1), cur_vu_point(2));
                        fprintf('Scaled point is (%f,%f) \n', scaled_vu_point(1), scaled_vu_point(2));
                        % pause;
                        
                        
                    else
                        rh_prettified_est_vu_array(iY, iX, :) =   rh_est_vu_array(iY, iX, :);
                        
                    end
                end
            end
        end
        
    end
    %pause;
    
else
    
    
        
    mesh_line_width = 1.5;
    
    
    
    
    rh_est_vu_array = nan*system.est_xy_accum_array;
    
    
    
    %First populate the array
    for iY = system.iY_array
        for iX = system.iX_array
            if(system.in_bounds(iY, iX))
                %          fprintf('Here! \n');
                %         system.rh_est_u_
                cur_pixel_rh_dist = system.rh_accum_array(iY, iX, :, :);
                cur_pixel_permuted_cond_dist = permute(cur_pixel_rh_dist, [3 4 1 2]);
                
                rh_est_vu_array(iY, iX, :)  = RhDistArray2VU(cur_pixel_permuted_cond_dist, size(cur_pixel_permuted_cond_dist, 1));
            end
        end
    end
    
    
    %Next de_modulo it
    
    
    rh_prettified_est_vu_array = rh_est_vu_array;
    rh_prettified_times_visited_mask = 0 * system.mesh.x;
    
    %We need to traverse the envrionment to get a consistent set of u,vs which
    %are de-modulo-ed. The way we do it now is just take the path of the animal
    %itself. It's a bit inefficient and hacky, but it should work.
    cur_vu_reference_point = rh_est_vu_array(path.iY(1), path.iX(1), :);
    
    
    
    iT = 1;
    
    while(sum(rh_prettified_times_visited_mask(:)) < sum(system.in_bounds(:)>0))
        iY = path.iY(iT);
        iX = path.iX(iT);
        cur_vu_point = rh_est_vu_array(iY, iX, :); %The un-modulo-ed new point
        cur_vu_reference_point = mod(cur_vu_point - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point); %Scale the unmodulo-ed point to the previous point
        
        rh_prettified_est_vu_array(iY, iX, :) =cur_vu_reference_point;
        rh_prettified_times_visited_mask(iY, iX) = 1;
        
        iT = iT + 1;
    end
    
    
    
    
    
    close all;
    
    [rh_est_y_mesh,  rh_est_x_mesh] = vu2yx(rh_prettified_est_vu_array(:, :, 1) * (2*pi/sysparams.rh_wave_vec), rh_prettified_est_vu_array(:, :, 2)* (2*pi/sysparams.rh_wave_vec));
    
    
    %m = mesh(rh_prettified_est_vu_array(:, :, 2), rh_prettified_est_vu_array(:, :, 1),  1.1  + 0*system.times_visited_array, 'LineWidth', mesh_line_width);
    view(gca,[0.0 0.0 90]);
    
    
    
    
    %Rotate by the original rotation angle. This way, withou any distortions we
    %have the same pattern
    de_rotation_angle = sysparams.rh_rot_angle * 0;
    
    
    rot_rh_est_x_mesh = cos(de_rotation_angle)* rh_est_x_mesh + sin(de_rotation_angle)* rh_est_y_mesh;
    rot_rh_est_y_mesh = -sin(de_rotation_angle)* rh_est_x_mesh+ cos(de_rotation_angle)* rh_est_y_mesh;
    
    
    rot_rh_est_x_mesh = rot_rh_est_x_mesh - nanmean(rot_rh_est_x_mesh(:));
    rot_rh_est_y_mesh = rot_rh_est_y_mesh - nanmean(rot_rh_est_y_mesh(:));
    %mesh_
    
    
    %The negative is to line up with other output images
    

    iX_stride = 1:sparsify_param:max(system.mesh.iX(:));
    iY_stride = 1:sparsify_param:max(system.mesh.iY(:));
    
    m = mesh(rot_rh_est_x_mesh(iY_stride, iX_stride), -rot_rh_est_y_mesh(iY_stride, iX_stride),  1.1  + 0*system.times_visited_array(iY_stride, iX_stride), 'LineWidth', mesh_line_width);
    set(m, 'EdgeColor', 'k');
    
    
    
    view(gca,[0.0 0.0 90]);
    daspect([1 1 1])
    min_x_in_box = min(system.mesh.x(system.in_bounds));
    min_y_in_box = min(system.mesh.y(system.in_bounds));
    
    max_x_in_box = max(system.mesh.x(system.in_bounds));
    max_y_in_box = max(system.mesh.y(system.in_bounds));
    
    x_lim = .75 *  (max_x_in_box - min_x_in_box) * [-1 1];
    y_lim = .75 *  (max_y_in_box - min_y_in_box) *[-1 1];
    
    
    xlim(x_lim);
    ylim(y_lim);
    
    
    set(gca, 'XTick', x_lim);
    set(gca, 'YTick', y_lim);
    
    
    %set(gca, 'XTick', x_lim * 1.5);
    %set(gca, 'YTick', y_lim* 1.5);
    
    %set(gca, 'XTick', x_lim * 1.5);
    %set(gca, 'YTick', y_lim* 1.5);
    
    
    fprintf('Max, min x is %f, %f \n', max(rh_est_x_mesh(:)), min(max(rh_est_x_mesh(:))));
    fprintf('Max, min y is %f, %f \n', max(rh_est_y_mesh(:)), min(max(rh_est_y_mesh(:))));
    
    output_png_file_path = sprintf('%s/RHXYMeshes/RHXYRun%d.png', sysparams.folder_path, run_num);
    output_fig_file_path = sprintf('%s/RHXYMeshes/FIGRHXYRun%d.fig', sysparams.folder_path, run_num);
    
    
    MakeFilePath(output_png_file_path);
    saveas(1, output_png_file_path);
    saveas(1, output_fig_file_path);
    
    %%%DONT need for now
    if(0)
        for iY = system.iY_array
            for iX = system.iX_array
                if(system.in_bounds(iY, iX))
                    
                    if(1)
                        if(system.in_bounds(iY-1, iX))
                            cur_vu_reference_point = rh_prettified_est_vu_array(iY-1, iX, :);
                            cur_vu_point = rh_est_vu_array(iY, iX, :);
                            rh_prettified_est_vu_array(iY, iX, :) =   mod(cur_vu_point - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point);
                        elseif (system.in_bounds(iY, iX-1))
                            cur_vu_reference_point = rh_prettified_est_vu_array(iY, iX-1, :);
                            cur_vu_point = rh_est_vu_array(iY, iX, :);
                            rh_prettified_est_vu_array(iY, iX, :) =   mod(cur_vu_point - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point);
                        else
                            cur_vu_reference_point  = nan * [1 1];
                            cur_vu_point = rh_est_vu_array(iY, iX, :);
                            rh_prettified_est_vu_array(iY, iX, :) =   rh_est_vu_array(iY, iX, :);
                        end
                        
                        scaled_vu_point = rh_prettified_est_vu_array(iY, iX, :);
                        
                        fprintf('Ref point is (%f,%f) \n', cur_vu_reference_point(1), cur_vu_reference_point(2));
                        fprintf('New point is (%f,%f) \n', cur_vu_point(1), cur_vu_point(2));
                        fprintf('Scaled point is (%f,%f) \n', scaled_vu_point(1), scaled_vu_point(2));
                        % pause;
                        
                        
                    else
                        rh_prettified_est_vu_array(iY, iX, :) =   rh_est_vu_array(iY, iX, :);
                        
                    end
                end
            end
        end
        
    end
    
end