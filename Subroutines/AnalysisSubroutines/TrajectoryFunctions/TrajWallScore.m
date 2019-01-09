function [wall_score] = TrajWallScore(traj)

norm_x = normalizeImage(traj.posx);
norm_y = normalizeImage(traj.posy);

wall_thresh = .1;
close_to_EW_wall = or(norm_x<.1, norm_x > .9);
close_to_NS_wall = or(norm_y<.1, norm_y > .9);
close_to_wall = or(close_to_NS_wall, close_to_EW_wall);
wall_score = mean(close_to_wall);