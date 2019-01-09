function [output_im_final] = FiringRateClockImage(system, z_accum_array, times_visited_array)

 
%Visualizes the 1D Attractor simulation read-out as an angle as a function of position

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


if(0)
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
resize_amount = 41;
line_thickness = 1;

output_im_with_lines = imresizeWithLines(output_image_rgb, resize_amount, yellow* .6,  1);


%%%%%%
for iX = system.iX_array
    for iY = system.iY_array
       if(times_visited_array(iY, iX) > 0)
            input_iX = iX;
            input_iY = iY;
%           input_iX = iX - min_x;
%           input_iY = iY - min_y;
           cur_comp_angle = z_accum_array(input_iY, input_iX);
           cur_angle = imag(log(z_accum_array(input_iY, input_iX)));
           cur_clock_im = MakeClockAngle(z_accum_array(input_iY, input_iX), resize_amount);
           output_im_with_lines(((input_iY-1) * resize_amount) + (1:resize_amount), ((input_iX-1) * resize_amount) + (1:resize_amount), :) = cur_clock_im;
       end       
    end    
end




min_iX = min(system.mesh.iX(system.in_bounds));
max_iX = max(system.mesh.iX(system.in_bounds));
min_iY = min(system.mesh.iY(system.in_bounds));
max_iY = max(system.mesh.iY(system.in_bounds));

iX_bounds=  ((min_iX -2)* resize_amount + 1):((max_iX+1)* resize_amount);
iY_bounds = ((min_iY -2)* resize_amount + 1):((max_iY+1)* resize_amount);
output_im_cropped = output_im_with_lines(iY_bounds, iX_bounds, :);
output_im_final = output_im_cropped;

%output_im_final  = output_im_with_lines;




%    mean_z_array = system.z_accum_array ./ system.times_visited_array;
%    imshow(output_image);



