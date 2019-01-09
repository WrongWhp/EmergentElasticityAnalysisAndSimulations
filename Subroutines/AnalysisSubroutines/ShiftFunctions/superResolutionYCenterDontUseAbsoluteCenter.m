function [estimated_peak] = superResolutionYCenter(array_to_use)

array_radius = ((size(array_to_use, 2) -1) /2)

y_center_array = array_to_use(array_radius + [0 1 2], array_radius + [0 2]) %Use the 6 entries around the center. 
%y_center_array = array_to_use;

y_heights = mean(y_center_array, 2)
poly_fit = polyfit( [-1 0 1]', y_heights, 2);
estimated_peak = -(1/2)  * poly_fit(2)/poly_fit(1);%Linear Component/Quadratic Component 
