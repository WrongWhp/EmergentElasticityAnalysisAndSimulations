function [dist] = RhVUToDistObj(rh_VU, rh_graining)
%Converts a single point on the periodic rhombus into an (aliased) one-hot
%distribution. The distribution is not represented as a full array, but
%rather a set of four indices and weights

rh_iVU = rh_VU * rh_graining;

%All of this is in zero-indexed units
iU = rh_iVU(2);
iV = rh_iVU(1);

iV_bot = mod(floor(iV), rh_graining);
iU_bot = mod(floor(iU), rh_graining);

iV_top = mod(iV_bot +1, rh_graining);
iU_top  = mod(iU_bot + 1, rh_graining);

u_weight = mod(iU, 1);
v_weight = mod(iV, 1);

%%%%

v_weight_array = [1-v_weight; v_weight]; %Vertical array
u_weight_array = [1-u_weight, u_weight]; %horizontal array
weight_array = v_weight_array * u_weight_array;





%my_array(1 + [v_bot v_top], 1 +[u_bot u_top])  =my_array(1 + [v_bot v_top], 1 +[u_bot u_top])  + weight_array;
%The +1 is to convert to matlab indexing
dist.weight_array = weight_array;
dist.iU_range = 1 + [iU_bot iU_top];
dist.iV_range = 1 + [iV_bot iV_top];


