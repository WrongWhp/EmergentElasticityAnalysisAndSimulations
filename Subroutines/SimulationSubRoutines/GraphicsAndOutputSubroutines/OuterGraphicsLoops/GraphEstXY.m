%Plots the mean position self-estimate as a function of *actual* position. 
mesh_line_width = 1.5;


for dont_plot_selfest_x = 0:1
    
    for dont_plot_selfest_y = 0:1
        
        for show_backdrop = 0:1
            
            close all
            
            
            if(show_backdrop)
                graph_interior_x = system.mesh.x;
                graph_interior_x(system.out_of_bounds) = nan;
                graph_interior_y = system.mesh.y;
                graph_interior_y(system.out_of_bounds) = nan;
                m = mesh(graph_interior_x, graph_interior_y,  1.1  + 0*system.times_visited_array, 'LineWidth', mesh_line_width);
                set(m, 'facecolor', 'none');
                set(m, 'EdgeColor', 'b');
                hold on;
                
            end
            if(1)
                outline_x = system.mesh.x;
                outline_y = system.mesh.y;
                outline_x(~system.is_inner_boundary) = nan;
                
                m = mesh(outline_x, outline_y,  1  + 0*system.times_visited_array,  'LineWidth', mesh_line_width);
                set(m, 'EdgeColor', 'b');                
                hold on;
            end
            
            reshaped_est_x = reshape(system.est_xy_accum_array(:, :, 1), system.box_size);
            reshaped_est_y = reshape(system.est_xy_accum_array(:, :, 2), system.box_size);
            
            
            
            reshaped_est_x(system.out_of_bounds) = nan;
            reshaped_est_y(system.out_of_bounds) = nan;
            
            reshaped_est_x = reshaped_est_x./system.times_visited_array;
            reshaped_est_y = reshaped_est_y./system.times_visited_array;
            
            my_color_map = [.6 .6 .6; .0 0 1];
%            colormap(my_color_map)
            
            reshaped_est_x = reshaped_est_x - mean(reshaped_est_x(system.times_visited_array>0)) + mean(system.mesh.x(system.times_visited_array>0));
            reshaped_est_y = reshaped_est_y - mean(reshaped_est_y(system.times_visited_array>0)) + mean(system.mesh.y(system.times_visited_array>0));
            
            %reshaped_
            if(dont_plot_selfest_x)
                reshaped_est_x = system.mesh.x;
            end
            if(dont_plot_selfest_y)
                reshaped_est_y = system.mesh.y;
            end
            
            m = mesh(reshaped_est_x, reshaped_est_y, 0 * system.times_visited_array,  'LineWidth', mesh_line_width);
            set(m, 'EdgeColor', 'k');
            
            %mesh(reshape(system.est_xy_accum_array(:, :, 1), system.box_size), reshape(system.est_xy_accum_array(:, :, 2), system.box_size), system.times_visited_array)
            view(gca,[0.0 0.0 90]);
            
            min_x_in_box = min(system.mesh.x(system.in_bounds));
            min_y_in_box = min(system.mesh.y(system.in_bounds));
            
            max_x_in_box = max(system.mesh.x(system.in_bounds));
            max_y_in_box = max(system.mesh.y(system.in_bounds));
            
            x_lim = [min_x_in_box max_x_in_box] + [-1 1];
            y_lim = [min_y_in_box max_y_in_box] + [-1 1];
            
            
            xlim(x_lim);
            ylim(y_lim);
            
            
            set(gca, 'XTick', x_lim);
            set(gca, 'YTick', y_lim);
            daspect([1 1 1])
            
            %set(gca, 'XTick', [0 max(reshaped_est_x(:))])
            %set(gca, 'YTick', [0 max(reshaped_est_y(:))])
            
            
            xlabel('X');
            ylabel('Y');
            %        output_file_path = sprintf('%s/Meshes/Run%dFudgeX%dFudgeY%d.png', sysparams.folder_path, run_num, fudge_x, fudg    e_y);
            output_file_path = sprintf('%s/Meshes/Backdrop%d/NoSelfEstX%dNoSelfEstY%d/Run%d.png', sysparams.folder_path, show_backdrop, dont_plot_selfest_x, dont_plot_selfest_y, run_num);
            
            MakeFilePath(output_file_path);
            saveas(1, output_file_path);
        end
    end
    
end

