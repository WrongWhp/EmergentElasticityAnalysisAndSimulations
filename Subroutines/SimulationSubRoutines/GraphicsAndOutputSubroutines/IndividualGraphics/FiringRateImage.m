function [output_im_final] = FiringRateImage(system, z_accum_array, times_visited_array)
 
%Computes a firing rate image from the distribution of 1D attractor states.
%

output_image_gray = zeros(system.box_size);
firing_rate_mask = logical(system.in_bounds .* (times_visited_array > 0));
output_image_gray(firing_rate_mask) =(.5 + .5 *real(z_accum_array(firing_rate_mask))) ./times_visited_array(firing_rate_mask);
output_image_rgb = gray2rgb(output_image_gray);

in_bounds_zero_visited_mask = logical(system.in_bounds .* (times_visited_array == 0));

cyan = [0 1 1];
brown = [.6 .3 0];
yellow = [1 1 0];
red = [1 0 0];

output_image_rgb =  colorAllRegions(output_image_rgb, ~system.in_bounds, brown);
output_image_rgb =  colorAllRegions(output_image_rgb, system.is_outer_boundary, cyan * .5);
output_image_rgb =  colorAllRegions(output_image_rgb, in_bounds_zero_visited_mask, red * .5);


if(1)
    bounding_box_obj= regionprops(system.in_bounds);
    bounding_box = floor(bounding_box_obj.BoundingBox);
    min_x = max(bounding_box(1), 1);
    min_y = max(bounding_box(2), 1);
    x_size = bounding_box(3);
    y_size = bounding_box(4);
    x_range = min_x:(min_x + x_size + 1);
    y_range = min_y:(min_y + y_size + 1);
    
%    size(output_image_rgb)
%    x_range
%    y_range
    output_image_rgb = output_image_rgb(y_range, x_range, :);
end


resize_amount = 40;

output_im_with_lines = imresizeWithLines(output_image_rgb, resize_amount, yellow* .6);
output_im_final  = output_im_with_lines;



