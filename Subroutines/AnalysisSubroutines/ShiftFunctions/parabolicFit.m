function [output_struct] = parabolicFit(array_to_use)

non_norm_x_range = 1:size(array_to_use,2);
non_norm_y_range = 1:size(array_to_use, 1);

x_range = non_norm_x_range - mean(non_norm_x_range);
y_range = non_norm_y_range - mean(non_norm_y_range);


[x_mesh, y_mesh] = meshgrid(x_range, y_range);



y_poly_fit = polyfit(y_mesh(:), array_to_use(:), 2);
output_struct.estimated_y_peak = -(1/2)  * y_poly_fit(2)/y_poly_fit(1);%
output_struct.dyy = y_poly_fit(1);



x_poly_fit = polyfit(x_mesh(:), array_to_use(:), 2);
output_struct.estimated_x_peak = -(1/2)  * x_poly_fit(2)/x_poly_fit(1);%
output_struct.dxx = x_poly_fit(1);


output_struct.peak_width = sqrt(max(array_to_use)/(output_struct.dxx + output_struct.dyy)); 
