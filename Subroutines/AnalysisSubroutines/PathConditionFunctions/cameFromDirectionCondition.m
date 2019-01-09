function [cond_met_indices] = cameFromDirectionCondition(traj, direction_cond)



time_step_length = mean(diff(traj.post));
ind_delay = round(direction_cond.time_offset/time_step_length);

%ind_delay
all_time_inds = 1:length(traj.post);

cond_not_met = zeros(size(all_time_inds));
cond_not_met(all_time_inds<=(ind_delay+1)) = 1;

prev_time_inds = max(all_time_inds - ind_delay, 1);



delta_x = (traj.posx(all_time_inds) - traj.posx(prev_time_inds)); %How much the x position has changed
delta_y = (traj.posy(all_time_inds) - traj.posy(prev_time_inds));%How much the y position is changed


delta_objective = delta_x * direction_cond.direction.x + delta_y * direction_cond.direction.y;
cond_not_met(delta_objective < direction_cond.min_dist) = 1;

cond_met  = ~cond_not_met;
cond_met_indices = find(cond_met);