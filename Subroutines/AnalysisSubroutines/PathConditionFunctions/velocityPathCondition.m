function [cond_met_indices] = velocityPathCondition(traj, direction_cond)


cond_met = (direction_cond.direction.x * traj.vel.x + direction_cond.direction.y * traj.vel.y) > 0;
cond_met_indices = find(cond_met);