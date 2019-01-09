function [cond_met_indices] = LastHitWallCondition(traj, direction_cond)

global ap;
dot_product_array = direction_cond.direction.x * traj.posx  + direction_cond.direction.y * traj.posy;
normalized_dot_array = (dot_product_array - nanmin(dot_product_array)) / (nanmax(dot_product_array)  - nanmin(dot_product_array));

dt = mean(diff(traj.post));

cur_time_since_wall = 0;
cond_met = zeros(size(traj.post));
time_since_wall_list = zeros(size(traj.post));
for i = 1:traj.N
    
    
    %If the value is low, it's hit the desired wall and we set it to true.
    away_from_wall = ~or(normalized_dot_array(i) > (1-ap.has_hit_wall_thresh),  normalized_dot_array(i) < ap.has_hit_wall_thresh);
    cur_time_since_wall = cur_time_since_wall + dt;
    cur_time_since_wall = away_from_wall * cur_time_since_wall;

    time_since_wall_list(i) = cur_time_since_wall;
end


cond_met = and(time_since_wall_list>=direction_cond.time_range(1), time_since_wall_list<direction_cond.time_range(2));
cond_met_indices = find(cond_met);