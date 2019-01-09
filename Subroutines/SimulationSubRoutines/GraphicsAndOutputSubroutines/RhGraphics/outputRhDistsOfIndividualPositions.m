

%A way to visualize the distrubtion of attractor network states as a
%function of position. Plots P(phi_u, phi_v | x, y). 

cur_count = 0;
for iY = 1:sysparams.array_height
    for iX = 1:sysparams.array_width
        if(system.in_bounds(iY, iX))
            fprintf('Doing %d /%d \n', cur_count, sum(system.in_bounds(:)));
            cur_count = cur_count + 1;
           dummy_firing_rate = -1 * ones(system.box_size);
           dummy_firing_rate(iY, iX) = 1;
           
           dummy_firing_rate_image = FiringRateImage(system, dummy_firing_rate, ones(system.box_size));
           rh_dist_for_posit = permute(prev_rh_accum(iY, iX, :, :), [3 4 1 2]);
           
           rh_dist_image = RhDistImage(rh_dist_for_posit);
           
           resize_amount = size(dummy_firing_rate_image, 1)/size(rh_dist_image, 1);
           
           resized_dist_image = imresize(rh_dist_image, resize_amount, 'nearest');
           
           cat_im = [dummy_firing_rate_image resized_dist_image];
           
           imwriteWithPath(cat_im, sprintf('%s/CheckingStuffDump/YFirst/InvididualDistOfPixeliY%diX%d.png', sysparams.folder_path, iY, iX));
           imwriteWithPath(cat_im, sprintf('%s/CheckingStuffDump/XFirst/InvididualDistOfPixeliX%diY%d.png', sysparams.folder_path, iX, iY));
           
        end        
    end
end

