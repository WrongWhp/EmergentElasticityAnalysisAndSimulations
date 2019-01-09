
%system.start_location = round([sysparams.array_width/2 sysparams.array_width/2 ])
fprintf('Generating random starting location ...   ');
start_loc_not_in_box = true;
while(start_loc_not_in_box)
    start_y = randi(sysparams.array_height, 1, 1);
    start_x = randi(sysparams.array_width, 1, 1);
    system.start_location = [start_y, start_x];
    
    start_loc_not_in_box = ~system.in_bounds(start_y, start_x);    
end

fprintf('Finished ! \n');