function [landmark_cell] = MakeEverywhereLandmarkCell(system);


mask_to_use = system.in_bounds;
rh_graining = size(system.rh_accum_array, 3);
strength = 0;

landmark_cell = MakeLandmarkCellFromMaskAndStrength(mask_to_use, rh_graining, strength);
landmark_cell.title = 'Everywhere';



