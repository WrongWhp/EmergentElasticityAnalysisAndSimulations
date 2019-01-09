function [cond_met_indices] = LastHitWallCondition(traj, direction_cond)

global ap;
dot_product_array = direction_cond.direction.x * traj.posx  + direction_cond.direction.y * traj.posy;
normalized_dot_array = (dot_product_array - nanmin(dot_product_array)) / (nanmax(dot_product_array)  - nanmin(dot_product_array));


cond_cur_met  = 0;

cond_met = zeros(size(traj.post));
for i = 1:traj.N
    
    %If the value is low, it's hit the desired wall and we set it to true.
    cur_dot = normalized_dot_array(i);
    cond_cur_met = or(cond_cur_met, cur_dot < ap.has_hit_wall_thresh);
    
    %If the value is too high, we've hit the opposite wall and we set it to
    %false
    cond_cur_met = and(cond_cur_met, or(cur_dot < (1-ap.has_hit_wall_thresh), isnan(cur_dot))  );
    cond_met(i) = cond_cur_met;
end


cond_met_indices = find(cond_met);