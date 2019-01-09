function [cond_met_indices] = willBeInDirectionCondition(traj, direction_cond)

fprintf('willBeInDirectionCondition \n');
global ap;
time_step_length = mean(diff(traj.post));
ind_offset = round(direction_cond.time_offset/time_step_length);

%ind_delay
all_time_inds = 1:traj.N;

cond_not_met = zeros(size(all_time_inds));
future_time = min(all_time_inds + ind_offset, traj.N);
cond_not_met(future_time == max(future_time)) = 1;



delta_x = (traj.posx(future_time)-traj.posx(all_time_inds)); %How much the x position has changed
delta_y = (traj.posy(future_time)- traj.posy(all_time_inds));%How much the y position is changed


delta_objective = delta_x * direction_cond.direction.x + delta_y * direction_cond.direction.y;
cond_not_met(delta_objective < ap.min_cond_dist) = 1;

cond_met  = ~cond_not_met;
cond_met_indices = find(cond_met);