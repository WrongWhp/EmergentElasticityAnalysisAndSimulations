function [output_im_final] = FiringRateContourImage(system, z_accum_array, times_visited_array)

 
%Computes a firing rate image from the distribution of 1D attractor states.
% Plots it as a contour plot 



firing_rate = zeros(system.box_size);
did_visit = logical(system.in_bounds .* (times_visited_array > 0));
firing_rate(did_visit) =(.5 + .5 *real(z_accum_array(did_visit))) ./times_visited_array(did_visit);


in_bounds_zero_visited_mask = logical(system.in_bounds .* (times_visited_array == 0));


resize_amount = 20;


%output_im_enlarged = imresize(output_image_gray, resize_amount, 'nearest');
resized_firing_rate = imresize(firing_rate, resize_amount, 'nearest');

resized_shouldnt_count = logical(imresize(double(times_visited_array == 0), resize_amount, 'nearest'));



blurred_resized_firing_rate_unnorm = imfilter(resized_firing_rate, fspecial('gaussian',  (4 * resize_amount + 1) * [1 1], resize_amount));
blurred_resized_firing_rate_norm = blurred_resized_firing_rate_unnorm./imfilter(~resized_shouldnt_count, fspecial('gaussian',  (4 * resize_amount + 1) * [1 1], resize_amount));


blurred_resized_firing_rate_norm = blurred_resized_firing_rate_norm- min(blurred_resized_firing_rate_norm(:));
blurred_resized_firing_rate_norm = blurred_resized_firing_rate_norm/max(blurred_resized_firing_rate_norm(:));
blurred_resized_firing_rate_norm(resized_shouldnt_count) = nan;
%imshow(blurred_resized_firing_rate);
%mpause;
blurred_resized_firing_rate_norm;
%output_im_final = output_image_gray

    
    mask = zeros ( size(blurred_resized_firing_rate_norm));
    
    for bounds = .45:.1:1
        mask = mask + (abs(blurred_resized_firing_rate_norm - bounds ) < .005);
    end
    
    mask(isnan(mask)) = 0;
    rgb_output_im = gray2rgb(blurred_resized_firing_rate_norm);
    rgb_output_im = colorAllRegions(rgb_output_im, logical(mask), [1 1 0]);
    output_im_final = rgb_output_im;

return;


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



%    mean_z_array = system.z_accum_array ./ system.times_visited_array;
%    imshow(output_image);



