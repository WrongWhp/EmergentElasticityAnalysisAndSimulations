

%A way to visualize the distrubtion of attractor network states as a
%function of position. Plots P(phi_u, phi_v | x, y). 


%edge_of_box = system.in_bounds;
has_max_x = system.mesh.x == max(system.mesh.x(system.in_bounds));
has_max_y = system.mesh.y == max(system.mesh.y(system.in_bounds));

has_min_x = system.mesh.x == min(system.mesh.x(system.in_bounds));
has_min_y = system.mesh.y == min(system.mesh.y(system.in_bounds));


edge_of_box = or( or(has_max_x, has_min_x), or(has_max_y, has_min_y));
edge_of_box = and(system.in_bounds, edge_of_box);
system_com = SystemCOM(system);
up_left_phi = cart2pol(min(system.mesh.x(system.in_bounds))- system_com.x,  max(system.mesh.y(system.in_bounds))- system_com.y);

cur_count = 0;
for iY = 1:sysparams.array_height
    for iX = 1:sysparams.array_width
        if(edge_of_box(iY, iX))
            fprintf('Doing %d /%d \n', cur_count, sum(edge_of_box(:)));
            cur_count = cur_count + 1;
           dummy_firing_rate = -1 * ones(system.box_size);
           dummy_firing_rate(iY, iX) = 1;
           
           dummy_firing_rate_image = FiringRateImage(system, dummy_firing_rate, ones(system.box_size));
           rh_dist_for_posit = permute(system.rh_accum_array(iY, iX, :, :), [3 4 1 2]);
           
           rh_dist_image = RhDistImage(rh_dist_for_posit);
           
           resize_amount = size(dummy_firing_rate_image, 1)/size(rh_dist_image, 1);
           
           resized_dist_image = imresize(rh_dist_image, resize_amount, 'nearest');
           
           cat_im = [dummy_firing_rate_image resized_dist_image];
           
           square_phi = cart2pol(system.x_array(iX) - system_com.x, system.y_array(iY) - system_com.y) -up_left_phi;
           if(square_phi<0);
               square_phi = square_phi + 2*pi;
           end
           imwriteWithPath(cat_im, sprintf('%s/CheckingStuffDump/ByAngle/Run%d/InvididualDistOfAngle%f.png', sysparams.folder_path,run_num, square_phi));
           
        end        
    end
end

