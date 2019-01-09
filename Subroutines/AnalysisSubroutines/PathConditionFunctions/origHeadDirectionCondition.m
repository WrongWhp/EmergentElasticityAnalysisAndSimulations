function [cond_met_indices] = origHeadDirectionCondition(traj, direction_cond)


cond_met = (direction_cond.direction.x * traj.unrotated_hd_x + direction_cond.direction.y * traj.unrotated_hd_x) > direction_cond.min_val;
cond_met_indices = find(cond_met);