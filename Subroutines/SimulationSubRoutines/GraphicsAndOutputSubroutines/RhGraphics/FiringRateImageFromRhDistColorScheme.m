function [output_im_final] = FiringRateImageFromRhDistColorScheme(system, rh_accum_array, times_visited_array, vu_shifts)


%Converts the attractor network state as a function of postion to grid cell
%firing rates. We have 3 "simulated" grid cells, which are phase-shifted
%versions to make visualization easier. 

%% Color map

%%


cur_color_map = colormap('jet');
cur_color_mult = .7;
cur_color_min = .2;

if(0)
    fprintf('Ratio of accum to visited is %f \n', sum(rh_accum_array(:))/sum(times_visited_array(:)));
    times_visited_for_each = sum(sum(rh_accum_array, 3), 4);
    fprintf('Max diff is %f \n', max(times_visited_for_each(:) - times_visited_array(:)));
end
output_image_rgb = zeros(system.box_size(1), system.box_size(2), 3);
for color_ind = 1:3
    firing_counts = FiringCountFromRhSmoothed(rh_accum_array, vu_shifts{1});
    
    output_image_gray = zeros(system.box_size);
    firing_rate_mask = logical(system.in_bounds .* (times_visited_array > 0));
    
    firing_rate_array = zeros(system.box_size);
    firing_rate_array(firing_rate_mask) = firing_counts(firing_rate_mask) ./times_visited_array(firing_rate_mask);
    %    fprintf('max is %f \n', max(firing_rate_array(:)))
    
    firing_rate_array = firing_rate_array/max(firing_rate_array(:));
    
    
    for iY = 1:size(output_image_rgb, 1)
        for iX = 1:size(output_image_rgb, 2)
                cur_firing_rate = cur_color_min +  firing_rate_array(iY, iX)  * cur_color_mult;
                cur_firing_rate = min(cur_firing_rate, 1);
                cur_firing_rate = max(cur_firing_rate, 0);
                cur_color_map_ind = max(round(64* cur_firing_rate ), 1);
 %               size(cur_color_map);
%                cur_color_map_ind
                color_map_value = cur_color_map(cur_color_map_ind, color_ind);
                output_image_rgb(iY, iX, color_ind) = color_map_value;
    
        end
    end
    
end

%output_image_gray = firing_rate_array;
%output_image_gray(firing_rate_mask) =(firing_counts(firing_rate_mask) ./times_visited_array(firing_rate_mask));
%output_image_rgb = gray2rgb(output_image_gray);

in_bounds_zero_visited_mask = logical(system.in_bounds .* (times_visited_array == 0));

cyan = [0 1 1];
brown = [.6 .3 0];
yellow = [1 1 0];
red = [1 0 0];
white = [1 1 1];
black = [0 0 0];
output_image_rgb =  colorAllRegions(output_image_rgb, ~system.in_bounds, white);
%output_image_rgb =  colorAllRegions(output_image_rgb, ~system.in_bounds, black);
output_image_rgb =  colorAllRegions(output_image_rgb, system.is_outer_boundary, white*.2);
output_image_rgb =  colorAllRegions(output_image_rgb, in_bounds_zero_visited_mask, white * .5);


if(1)
    bounding_box_obj= regionprops(system.in_bounds);
    bounding_box = floor(bounding_box_obj.BoundingBox);
    %    bounding_box
    min_x = round(bounding_box(1));
    min_y = round(bounding_box(2));
    x_size = bounding_box(3);
    y_size = bounding_box(4);
    x_range = min_x:(min_x + x_size + 1);
    y_range = min_y:(min_y + y_size + 1);
    
    output_image_rgb = output_image_rgb(y_range, x_range, :);
end


resize_amount = 40;
output_im_with_lines = imresizeWithLines(output_image_rgb, resize_amount, yellow* .2);
output_im_final  = output_im_with_lines;



%    mean_z_array = system.z_accum_array ./ system.times_visited_array;
%    imshow(output_image);



