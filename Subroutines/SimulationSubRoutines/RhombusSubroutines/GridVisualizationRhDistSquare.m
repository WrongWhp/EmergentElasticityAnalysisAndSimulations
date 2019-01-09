function [dist] = GridVisualizationRhDistSquare(rh_graining)


%rh_graining = 15;
%Creates a circular mask as a function of (phi_u, phi_v). 

iU = 1:rh_graining;
iV = 1:rh_graining;


scaled_u = 1*iU/rh_graining;
scaled_v = 1*iV/rh_graining;

dist = zeros(rh_graining, rh_graining);

[scaled_u_mesh, scaled_v_mesh] = meshgrid(scaled_u, scaled_v);



first_line_exp = mod(scaled_v_mesh + .5, 1)-.5;
sec_line_exp = mod(scaled_v_mesh + .1, 1) - .5;
third_line_exp = mod(2 * scaled_u_mesh  +1  * scaled_v_mesh + .5, 1) - .5;

%first_line_exp = 

first_lines = exp(-75 *  first_line_exp.^2);
sec_lines = exp(-75 *  sec_line_exp.^2);
third_lines = exp(-75 *  third_line_exp.^2);



dist =  max(dist, first_lines);
dist = max(dist, sec_lines);
dist = max(dist, third_lines);
%dist = dist + exp(-35 *  third_line_exp.^2);


%sec_line_exp = mod(two_v_mesh + .5, 1)-.5;


%sec_line_exp = mod(two_v_mesh + 
%sec_line_exp = mod(two_v_mesh + .5, 1)-.5;



%line_1 = exp(
%close all;
%imshow(dist)



