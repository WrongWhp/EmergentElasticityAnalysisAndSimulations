function [landmark_cell] = MakeLandmarkCellFromMaskAndStrength(mask, rh_graining, strength);


landmark_cell.mask = double(mask);
landmark_cell.strength = strength;

landmark_cell.learned_z = 0;
landmark_cell.rh_dist_array = zeros(rh_graining);
landmark_cell.rh_V_forcing = zeros(rh_graining);
landmark_cell.rh_U_forcing = zeros(rh_graining);



landmark_cell.learned_xy = nan * [0 0];
landmark_cell.title = 'defaultLandmarkCell';