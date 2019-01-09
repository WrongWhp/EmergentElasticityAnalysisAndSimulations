function [rh_VU] = RHDistArray2VU(rh_dist, rh_graining)
%Converts a single point on the periodic rhombus into an (aliased) one-hot
%distribution. 

rh_u = ((1:rh_graining)-1)/(rh_graining);
rh_v = ((1:rh_graining)-1)/(rh_graining);


[rh_u_mesh, rh_v_mesh] = meshgrid(rh_u, rh_v);

distance_squared_filter = circshift(CenteredRHDistanceArray(rh_graining), floor(rh_graining/2) * [1 1]);

distance_squared_from_rh_dist = imfilter(rh_dist, distance_squared_filter, 'circular');%Find the 

[iV_max, iU_max] = find(distance_squared_from_rh_dist == min(distance_squared_from_rh_dist(:)));


rh_VU_center = [rh_v(iV_max),  rh_u(iU_max)];
rh_u_mesh_delta = mod(rh_u_mesh - rh_VU_center(2) + .5, 1) -.5;
rh_v_mesh_delta = mod(rh_v_mesh - rh_VU_center(1) + .5, 1) -.5;

 
rh_VU = rh_VU_center + [sum(rh_dist(:) .* rh_v_mesh_delta(:)), sum(rh_dist(:) .* rh_u_mesh_delta(:))]/sum(rh_dist(:));
