function [colored_image] = ImageCopyPaste(image_to_color, mask,  source)
colored_image  = image_to_color;

for color_ind = 1:3
    cur_marked_image_color = image_to_color(:, :, color_ind);
    source_color = source(:, :, color_ind);
    cur_marked_image_color(mask) = source_color(mask);
    colored_image(:, :, color_ind) = cur_marked_image_color;
    
%    marked_image(center_mass_marker_mask, color_ind) = center_mass_marker_color(color_ind);
%    cur_marked_image_color    
end














