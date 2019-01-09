
%1 is ("Eastward"), 2 is ("Westward"), 3 is ("Northward"), 4 is ("Southward")
east_dir = struct('x', 1, 'y', 0);
west_dir = struct('x',-1, 'y', 0);
north_dir = struct('x',0, 'y', 1);
south_dir = struct('x',0, 'y',-1);

orig_head_dir_conds{1} = struct('type', 'OrigHeadDir', 'direction', east_dir, 'min_val', 0, 'name', 'Head Direction East', 'axis', 'EW');
orig_head_dir_conds{2} = struct('type', 'OrigHeadDir', 'direction', west_dir, 'min_val', 0, 'name', 'Head Direction West', 'axis', 'EW');
orig_head_dir_conds{3} = struct('type', 'OrigHeadDir', 'direction', north_dir, 'min_val', 0, 'name', 'Head Direction North', 'axis', 'NS');
orig_head_dir_conds{4} = struct('type', 'OrigHeadDir', 'direction', south_dir, 'min_val', 0, 'name', 'Head Direction South', 'axis', 'NS');


head_dir_conds{1} = struct('type', 'HDRot', 'direction', east_dir, 'min_val', 0, 'name', 'Head Direction East', 'axis', 'EW');
head_dir_conds{2} = struct('type', 'HDRot', 'direction', west_dir, 'min_val', 0, 'name', 'Head Direction West', 'axis', 'EW');
head_dir_conds{3} = struct('type', 'HDRot', 'direction', north_dir, 'min_val', 0, 'name', 'Head Direction North', 'axis', 'NS');
head_dir_conds{4} = struct('type', 'HDRot', 'direction', south_dir, 'min_val', 0, 'name', 'Head Direction South', 'axis', 'NS');

strong_head_dir_conds{1} = struct('type', 'HDStrong', 'direction', east_dir, 'min_val', sqrt(.5), 'name', 'Head Direction East', 'axis', 'EW');
strong_head_dir_conds{2} = struct('type', 'HDStrong', 'direction', west_dir, 'min_val', sqrt(.5), 'name', 'Head Direction West', 'axis', 'EW');
strong_head_dir_conds{3} = struct('type', 'HDStrong', 'direction', north_dir, 'min_val', sqrt(.5), 'name', 'Head Direction North', 'axis', 'NS');
strong_head_dir_conds{4} = struct('type', 'HDStrong', 'direction', south_dir, 'min_val', sqrt(.5), 'name', 'Head Direction South', 'axis', 'NS');



last_wall_nonex_conds{1} = struct('type', 'Last Wall NonExclusive', 'direction', east_dir, 'name',  'Last Hit West Wall', 'axis', 'EW');
last_wall_nonex_conds{2} = struct('type', 'Last Wall NonExclusive', 'direction', west_dir, 'name', 'Last Hit East Wall', 'axis', 'EW');
last_wall_nonex_conds{3} = struct('type', 'Last Wall NonExclusive', 'direction', north_dir, 'name', 'Last Hit South Wall', 'axis', 'NS');
last_wall_nonex_conds{4} = struct('type', 'Last Wall NonExclusive', 'direction', south_dir, 'name', 'Last Hit North Wall', 'axis', 'NS');


prev_posit_conds{1} = struct('type', 'PrevPosition', 'direction', east_dir, 'time_offset', ap.past_cond_time_delay, 'min_dist', ap.min_cond_dist,'name', 'Came From West', 'axis', 'EW');
prev_posit_conds{2} = struct('type', 'PrevPosition', 'direction', west_dir, 'time_offset', ap.past_cond_time_delay,'min_dist', ap.min_cond_dist, 'name', 'Came From East', 'axis', 'EW');
prev_posit_conds{3} = struct('type', 'PrevPosition', 'direction', north_dir,'time_offset', ap.past_cond_time_delay,'min_dist', ap.min_cond_dist, 'name', 'Came From South', 'axis', 'NS');
prev_posit_conds{4} = struct('type', 'PrevPosition', 'direction', south_dir,'time_offset', ap.past_cond_time_delay,'min_dist', ap.min_cond_dist, 'name', 'Came From North', 'axis', 'NS');


fut_posit_conds{1} = struct('type', 'FuturePosition', 'direction', east_dir,  'time_offset', ap.future_cond_time_offset, 'name', 'Will Be East', 'axis', 'EW');
fut_posit_conds{2} = struct('type', 'FuturePosition', 'direction', west_dir,  'time_offset', ap.future_cond_time_offset, 'name', 'Will Be West', 'axis', 'EW');
fut_posit_conds{3} = struct('type', 'FuturePosition', 'direction', north_dir, 'time_offset', ap.future_cond_time_offset, 'name', 'Will Be North', 'axis', 'NS');
fut_posit_conds{4} = struct('type', 'FuturePosition', 'direction', south_dir, 'time_offset', ap.future_cond_time_offset, 'name', 'Will Be South', 'axis', 'NS');


vel_conds{1} = struct('type', 'Velocity', 'direction', east_dir,   'name', 'Vel East', 'axis', 'EW');
vel_conds{2} = struct('type', 'Velocity', 'direction', west_dir,   'name', 'Vel West', 'axis', 'EW');
vel_conds{3} = struct('type', 'Velocity', 'direction', north_dir,  'name', 'Vel North', 'axis', 'NS');
vel_conds{4} = struct('type', 'Velocity', 'direction', south_dir,  'name', 'Vel South', 'axis', 'NS');






wall_time = 10;
time_since_any_wall_conds{1} = struct('type', 'TimeSinceWallSym', 'direction', east_dir, 'time_range', [0 wall_time], 'name',  'Recently Hit EW', 'axis', 'EW');
time_since_any_wall_conds{2} = struct('type', 'TimeSinceWallSym', 'direction', east_dir, 'time_range', [wall_time inf], 'name',  'Hasnt Hit EW', 'axis', 'EW');

time_since_any_wall_conds{3} = struct('type', 'TimeSinceWallSym', 'direction', north_dir, 'time_range', [0 wall_time], 'name',  'Recently Hit NS', 'axis', 'NS');
time_since_any_wall_conds{4} = struct('type', 'TimeSinceWallSym', 'direction', north_dir, 'time_range', [wall_time inf], 'name',  'Hasnt Hit NS', 'axis', 'NS');


for i = 1:4
    cur_wall_history_cond = last_wall_nonex_conds{i};
    cur_path_dir_cond = prev_posit_conds{i};
    name_of_cond = sprintf('Path(WallControlled) %s ', cur_path_dir_cond.name);
    
    path_wall_controlled_conds{i} =  struct('type', 'PathWallControlled', 'direction', cur_path_dir_cond.direction, 'name', name_of_cond, 'axis', cur_path_dir_cond.axis);
    path_wall_controlled_conds{i}.base_cond = cur_path_dir_cond;
    path_wall_controlled_conds{i}.controlled_for_cond = cur_wall_history_cond;
end

for i = 1:4
    cur_wall_history_cond = last_wall_nonex_conds{i};
    cur_path_dir_cond = vel_conds{i};
    name_of_cond = sprintf('Wall(PathControlled) %s ', cur_wall_history_cond.name);
    
    wall_vel_controlled_conds{i} =  struct('type', 'WallPathControlled', 'direction', cur_path_dir_cond.direction, 'name', name_of_cond, 'axis', cur_path_dir_cond.axis);
    wall_vel_controlled_conds{i}.controlled_for_cond = cur_path_dir_cond;
    wall_vel_controlled_conds{i}.base_cond = cur_wall_history_cond;
end



if(0)
    for j = 1:5
        cur_conds = prev_posit_conds;
        
        for i= 1:4
            cur_delay  = j*4;
            cur_conds{i}.time_offset = cur_delay;
            cur_conds{i}.name = sprintf('%s %d',cur_conds{i}.name, cur_delay);
        end
        path_condition_array{j} = cur_conds;
    end
end



for i = 1:4
    cur_wall_cond = last_wall_nonex_conds{oppositeDirectionInd(i)};
    cur_came_from_dir_cond = prev_posit_conds{i};
    
    name_to_use = sprintf('%s But %s', cur_wall_cond.name, cur_came_from_dir_cond.name);
    
    cur_path_cond =  struct('type', 'IntersectionWallOppPath', 'direction', cur_wall_cond.direction,   'name', name_to_use, 'axis', cur_wall_cond.axis);
    
    cur_path_cond.cond_1 = cur_wall_cond;
    cur_path_cond.cond_2 = cur_came_from_dir_cond;
    
    wall_opp_path_conds{i} = cur_path_cond;
end

for i = 1:4
    cur_vel_cond = vel_conds{oppositeDirectionInd(i)};
    cur_came_from_dir_cond = prev_posit_conds{i};
    
    name_to_use = sprintf('%s But %s', cur_vel_cond.name, cur_came_from_dir_cond.name);
    
    cur_path_cond =  struct('type', 'IntersectionVelOppPath', 'direction', cur_vel_cond.direction,   'name', name_to_use, 'axis', cur_vel_cond.axis);
    
    cur_path_cond.cond_1 = cur_vel_cond;
    cur_path_cond.cond_2 = cur_came_from_dir_cond;
    
    vel_opp_path_conds{i} = cur_path_cond;
end

for i = 1:4
    cur_vel_cond = vel_conds{i};
    cur_came_from_dir_cond = prev_posit_conds{i};
    
    name_to_use = sprintf('%s AND %s', cur_vel_cond.name, cur_came_from_dir_cond.name);
    
    cur_path_cond =  struct('type', 'IntersectionVelOppPath', 'direction', cur_vel_cond.direction,   'name', name_to_use, 'axis', cur_vel_cond.axis);
    
    cur_path_cond.cond_1 = cur_vel_cond;
    cur_path_cond.cond_2 = cur_came_from_dir_cond;
    
    vel_with_path_conds{i} = cur_path_cond;
end


if(1)
    path_condition_array{1} = head_dir_conds;
    path_condition_array{2} = orig_head_dir_conds;
    
    path_condition_array{3} = vel_conds;
    path_condition_array{4} = last_wall_nonex_conds;
    path_condition_array{5} = path_wall_controlled_conds;
    path_condition_array{6} = wall_vel_controlled_conds;
    path_condition_array{7} = wall_opp_path_conds;
    path_condition_array{8} = vel_opp_path_conds;
    path_condition_array{9} = vel_with_path_conds;
    path_condition_array{10} = fut_posit_conds;
    path_condition_array{11} = prev_posit_conds;
    
    
end
%path_condition_array{4} = prev_posit_conds;
%path_condition_array{5} = fut_posit_conds;
%path_condition_array{6} = time_since_any_wall_conds;





if(0)
    
    
    
    
    
    for i = 1:4
        cur_wall_cond = last_wall_nonex_conds{i};
        cur_came_from_dir_cond = prev_posit_conds{i};
        name_to_use = sprintf('%s AND %s', cur_wall_cond.name, cur_came_from_dir_cond.name);
        cur_path_cond =  struct('type', 'Intersection', 'direction', cur_wall_cond.direction,   'name', name_to_use, 'axis', cur_wall_cond.axis);
        cur_path_cond.cond_1 = cur_wall_cond;
        cur_path_cond.cond_2 = cur_came_from_dir_cond;
        path_condition_array{10}{i} = cur_path_cond;
    end
    
    
    
    
    for i = 1:4
        cur_path_history_cond = prev_posit_conds{i};
        cur_head_dir_cond = path_condition_array{1}{i};
        
        name_of_cond = sprintf('(HD Controlled Path) %s ', cur_path_history_cond.name);
        
        path_condition_array{5}{i} = struct('type', 'ControlledPrevPosition', 'direction', cur_head_dir_cond.direction, 'name', name_of_cond, 'axis', cur_head_dir_cond.axis);
        
        path_condition_array{5}{i}.base_cond = cur_path_history_cond;
        path_condition_array{5}{i}.controlled_for_cond = cur_head_dir_cond;
    end
    
    for i = 1:4
        cur_wall_history_cond = last_wall_nonex_conds{i};
        cur_head_dir_cond = path_condition_array{1}{i};
        
        name_of_cond = sprintf('(HD Controlled Wall) %s ', cur_wall_history_cond.name);
        path_condition_array{6}{i} = struct('type', 'ControlledLastWall', 'direction', cur_head_dir_cond.direction, 'name', name_of_cond, 'axis', cur_head_dir_cond.axis);
        path_condition_array{6}{i}.base_cond = cur_wall_history_cond;
        path_condition_array{6}{i}.controlled_for_cond = cur_head_dir_cond;
    end
    
    
    for i = 1:4
        cur_wall_history_cond = last_wall_nonex_conds{i};
        cur_head_dir_cond = path_condition_array{1}{i};
        
        name_of_cond = sprintf('HD(Wall Controlled) %s ', cur_head_dir_cond.name);
        path_condition_array{7}{i} = struct('type', 'WallControlledHD', 'direction', cur_head_dir_cond.direction, 'name', name_of_cond, 'axis', cur_head_dir_cond.axis);
        path_condition_array{7}{i}.base_cond = cur_head_dir_cond;
        path_condition_array{7}{i}.controlled_for_cond = cur_wall_history_cond;
    end
end

