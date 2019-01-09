function [force] = TwoBodyRhForceLaw(attract_phase, landmark_phase)

%vu_attract_phase = yx2vuArray(attract_phase);
%vu_landmark_phase = yx2vuArray(landmark_phase);


U_shift = [1 1 1 0 0 0 -1 -1 -1];
V_shift = [1 0 -1 1 0 -1 1 0 -1];


sep_vector_list = zeros(9, 2);

%distance_list = zeros(9, 1);

%distance_cube = zeros(rh_graining, rh_graining, 9);

%[base_rh_iY, base_rh_iX] = vu2yx(1, 1);


%Does periodic boundary conditions
for shift_ind = 1:9
    cur_shifted_attract_xy = attract_phase + vu2yxArray([V_shift(shift_ind) U_shift(shift_ind)]);
    sep_vector_list(shift_ind, :) = cur_shifted_attract_xy - landmark_phase;
end
[~, min_shift_ind] = min(sum(sep_vector_list.^2,2)) 
sep_vector = sep_vector_list(min_shift_ind, :);

force = (sep_vector/norm(sep_vector)) * AttractorNetworkForceLaw(norm(sep_vector));