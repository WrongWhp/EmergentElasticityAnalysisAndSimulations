function [rh_dist] = RhVUToDistArray(rh_VU, rh_graining)
%Converts a single point on the periodic rhombus into an (aliased) one-hot
%distribution. 

rh_dist = zeros(rh_graining, rh_graining);
rh_dist_obj = RhVUToDistObj(rh_VU, rh_graining);

rh_dist_obj
rh_dist(rh_dist_obj.iV_range,rh_dist_obj.iU_range) = rh_dist_obj.weight_array;

