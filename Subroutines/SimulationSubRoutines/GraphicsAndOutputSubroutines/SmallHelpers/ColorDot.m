function [colored_image] = ColorDot(image_to_color, center_x, center_y, circle_size, color_to_use)
colored_image  = image_to_color;



[x_mesh, y_mesh] = meshgrid(1:size(image_to_color, 2), meshgrid(1:size(image_to_color), 1));
dist_squared_x = (x_mesh-center_x).^2;
dist_squared_y = (y_mesh-center_y).^2;

marker_mask = dist_squared_x + dist_squared_y < (circle_size^2);


for color_ind = 1:3
    cur_marked_image_color = image_to_color(:, :, color_ind);
    cur_marked_image_color(marker_mask) = color_to_use(color_ind);
    colored_image(:, :, color_ind) = cur_marked_image_color;
    
%    marked_image(center_mass_marker_mask, color_ind) = center_mass_marker_color(color_ind);
%    cur_marked_image_color    
end














