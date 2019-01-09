function [weighting, total_mean_strength] = wallLocalWeighting(sysparams, system, landmark_cell_list)


wall_total = 0;
local_total = 0;

for i = 1:length(landmark_cell_list)
    cur_landmark_cell = landmark_cell_list{i};
    cur_LM_mean_strength = cur_landmark_cell.strength * mean(cur_landmark_cell.mask(system.in_bounds));
    if(strcmp(cur_landmark_cell.title, 'MakeCircularLandmarkCell'));
        local_total = local_total + cur_LM_mean_strength;
    else
        wall_total = wall_total + cur_LM_mean_strength;        
    end
    
end

weighting = wall_total/(wall_total + local_total);
total_mean_strength = sysparams.spacing.^2 * sum(system.in_bounds(:)) * (local_total + wall_total);%Strength time area

