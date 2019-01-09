function [traj] = shiftPositionByHD(traj, pixels)



    %%%%%%%%%%Moving the psychological center to the nose. Don't want to do
    %%%%%%%%%%this for the long term
    traj.posx = traj.posx + traj.hd_x * pixels;
    traj.posy = traj.posy + traj.hd_y * pixels;    
    %%%%%%%%%    

