function [cond_met_indices] = headDirectionCondition(traj, direction_cond)


cond_met = (direction_cond.direction.x * traj.hd_x + direction_cond.direction.y * traj.hd_y) > direction_cond.min_val;
cond_met_indices = find(cond_met);