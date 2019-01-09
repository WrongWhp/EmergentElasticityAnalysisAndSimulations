%rh_est_vu_array

iY_iX_list = [];

has_point = system.in_bounds * 0;



for target_v = -.025:.01:1.4 %We overshoot 1 for rounding reasons
    for target_u = -.025:.01:1.4
        target_VU = [target_v target_u]';
        target_VU
        if(sum(IsBetween(target_VU, .52, .53))>0) %To get a cross
            
            for iX = 1:(system.box_size(2) - 1)
                for iY = 1:(system.box_size(1) - 1)
                    
                    sum_in_bounds = sum(sum(system.in_bounds(iY + [0 1], iX + [0 1])));
                    if( sum_in_bounds> 3.5)
                        %  fprintf('here! \n')
                        cur_vu_cube =rh_est_vu_array(iY + [0 1], iX + [0 1], :);
                        
                        unrolled_vu_cube = cur_vu_cube;
                        
                        cur_vu_reference_point = cur_vu_cube(1, 1, :);
                        unrolled_vu_cube(1, 2, :) =   mod(unrolled_vu_cube(1, 2, :) - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point);
                        unrolled_vu_cube(2, 1, :) =   mod(unrolled_vu_cube(2, 1, :) - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point);
                        unrolled_vu_cube(2, 2, :) =   mod(unrolled_vu_cube(2, 2, :) - (-.5 + cur_vu_reference_point), 1) +  (-.5 + cur_vu_reference_point);
                        
                        
                        
                        iY_to_V = mean(unrolled_vu_cube(2, :, 1) - unrolled_vu_cube(1, :, 1));
                        iY_to_U = mean(unrolled_vu_cube(2, :, 2) - unrolled_vu_cube(1, :, 2));
                        
                        iX_to_V = mean(unrolled_vu_cube(:, 2, 1) - unrolled_vu_cube(:, 1, 1));
                        iX_to_U = mean(unrolled_vu_cube(:, 2, 2) - unrolled_vu_cube(:, 1, 2));
                        
                        YX_to_VU_matrix = [ iY_to_V iX_to_V ; iY_to_U iX_to_U];
                        if(std(YX_to_VU_matrix(:))>.1)
                            YX_to_VU_matrix
                            pause
                        end
                        
                        %There might still be a little bit of an issue with target vu
                        %around 1
                        
                        %                target_VU = [.99 .99]';
                        delta_iY_iX = YX_to_VU_matrix\ (target_VU - cur_vu_reference_point(:)); %What sort of YX to we need to get the desired vu
                        %            cur_vu_reference_point(:)'
                        %            delta_iY_iX
                        %            pause;
                        if(sum(IsBetween(delta_iY_iX, 0, 1.00)) == 2)
                            iY_iX_list(size(iY_iX_list, 1) + 1, :) = [iY iX] + delta_iY_iX';
                            %                iY_iX_list
                            %            pause;
                            has_point(iY,iX) = has_point(iY,iX)+1;
                        end
                        
                    end
                end
            end
            
        end
        
        
    end
end

close all
scatter(iY_iX_list(:, 2) /sysparams.graining, -iY_iX_list(:, 1)/sysparams.graining, '.k', 'LineWidth', 2)
hold on;

x_to_mesh = system.mesh.x;
y_to_mesh = system.mesh.y;
y_to_mesh(~system.is_inner_boundary) = nan;
x_to_mesh(~system.is_inner_boundary) = nan;

mesh(x_to_mesh, -y_to_mesh,  1.1  + 0*system.times_visited_array, 'LineWidth', mesh_line_width);
%mesh(system.mesh.x(system.is_inner_boundary), -system.mesh.y(system.is_inner_boundary), 'k');

%scatter(system.mesh.x(system.is_inner_boundary), -system.mesh.y(system.is_inner_boundary), 'k');

