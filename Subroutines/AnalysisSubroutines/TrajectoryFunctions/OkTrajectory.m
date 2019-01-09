function [ok_traj has_hd] = OkTrajectory(trajectory_file_name);
load(trajectory_file_name);

ok_traj = exist('posx') && exist('posy') && exist('post');


has_hd = exist('posx2') && exist('posy2');


if(has_hd)
   has_hd = (length(posx2) > 0 ) && (length(posy2)> 0)    
end