function [traj_struct] = LoadTrajectory(trajectory_file_name);

global ap;
load(trajectory_file_name);
%fprintf('At LoadTrajectory');
if(exist('posy2') && length(posy2) > 0)
    
    
    
    
    
    if(1)
        %Trims data
       fprintf('Note-Trimming end of trajectory data because indices are mismatched \n');
       record_length_array = 1:length(post);
       posy = posy(record_length_array);
       posy2 = posy2(record_length_array);
       posx = posx(record_length_array);
       posx2 = posx2(record_length_array);
    end
    traj_struct.has_hd = true;
    
    
    
    
    
    max_y = nanmax(nanmax(posy2), nanmax(posy));
    posy2 = max_y -posy2;
    posy = max_y -posy;
    
    traj_struct.posx = (posx + posx2)/2.;
    traj_struct.posy = (posy + posy2)/2.;
    traj_struct.post = post;
    
    
    delta_x = posx - posx2; % The distance and direction between the two LEDs is orthogonal to head direction
    delta_y = posy - posy2;
    norm_delta = sqrt(delta_x.^2 + delta_y.^2);
    
    

    
    traj_struct.hd_x = -delta_y./norm_delta;
    traj_struct.hd_y = delta_x./norm_delta;
    
    traj_struct.hd_diode_sep = norm_delta;
    
    
    if(1)
        %If there is too big a separation between the two diodes we assume
        %there was some sort of tracking error 
       too_big_sep = traj_struct.hd_diode_sep >  2 * nanmedian(traj_struct.hd_diode_sep);
        
       traj_struct.posx(too_big_sep)  = nan;
       traj_struct.posy(too_big_sep)  = nan;
       traj_struct.hd_x(too_big_sep)  = nan;
       traj_struct.hd_y(too_big_sep)  = nan;
       
    end
    
    
    if(1)
        posx_range = max(traj_struct.posx)  -min(traj_struct.posx);
        posy_range = max(traj_struct.posy) - min(traj_struct.posy)
       if(posy_range > 1.2 * posx_range) %Assume camera got rotated
           tmp_hd_y = traj_struct.hd_x;
           tmp_hd_x = -traj_struct.hd_y;
           tmp_posy = traj_struct.posx;           
           tmp_posx = -traj_struct.posy;           
           
           traj_struct.posx = tmp_posx;
           traj_struct.posy = tmp_posy;
           traj_struct.hd_x = tmp_hd_x;
           traj_struct.hd_y = tmp_hd_y;           
           
       end
        
    end
    
    traj_struct.vel = calculateVelocity(traj_struct);
    traj_struct.N =  length(traj_struct.posx);
    
    
    
else
    traj_struct.has_hd = false;
    
    
    max_y = nanmax(nanmax(posy));
    posy = max_y -posy;
    
    traj_struct.posx = posx;
    traj_struct.posy = posy;
    traj_struct.post = post;
    
    traj_struct.hd_x = nan * post;
    traj_struct.hd_y = nan * post;
    
    traj_struct.vel = calculateVelocity(traj_struct);
    
    traj_struct.N =  length(traj_struct.posx);
    
end

traj_struct.unrotated_hd_x = traj_struct.hd_x;
traj_struct.unrotated_hd_y = traj_struct.hd_y;

