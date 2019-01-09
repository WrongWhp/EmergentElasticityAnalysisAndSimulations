function [traj] = NormalizeToCentimeters(traj, cm)


max_y = nanmax(traj.posy);
min_y = nanmin(traj.posy);

max_x = nanmax(traj.posx);
min_x = nanmin(traj.posx);


total_max_min = max(max_y - min_y, max_x - min_x);

traj.posy = cm * (traj.posy - .5 * (max_y + min_y)  )/(total_max_min);
traj.posx = cm * (traj.posx - .5 * (max_x + min_x)  )/(total_max_min);

