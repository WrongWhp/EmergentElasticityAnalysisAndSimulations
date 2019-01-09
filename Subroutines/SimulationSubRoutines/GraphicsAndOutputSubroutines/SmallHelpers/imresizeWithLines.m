function [output_im_with_lines] = imresizeWithLines(input_image, resize_amount, line_color, opt1)

%fprintf('Nargin %d \n', nargin);
if(nargin < 4)
    line_thickness = 2;    
else
   line_thickness = opt1; 
end
    


if(size(input_image, 3) == 1)
   input_image = gray2rgb(input_image); 
end

output_im_enlarged = imresize(input_image, resize_amount, 'nearest');
line_drawing_mask = logical(zeros(size(output_im_enlarged(:, :, 1))));
iX_list = 1:size(line_drawing_mask, 2);
iY_list = 1:size(line_drawing_mask, 1);

ok_iX = mod(iX_list - 1, resize_amount) < line_thickness;
ok_iY = mod(iY_list - 1, resize_amount) < line_thickness;

ok_iY(size(line_drawing_mask, 1) + ((-line_thickness+1):0) ) = true;
ok_iX(size(line_drawing_mask, 2) + ((-line_thickness+1):0) ) = true;
%The last squares will be a little bit smaller, doesn't matter for now



x_line_list = iX_list(ok_iX);
y_line_list = iY_list(ok_iY);
line_drawing_mask(y_line_list, :) = 1;
line_drawing_mask(:, x_line_list) = 1;


output_im_with_lines = colorAllRegions(output_im_enlarged, line_drawing_mask, line_color);



