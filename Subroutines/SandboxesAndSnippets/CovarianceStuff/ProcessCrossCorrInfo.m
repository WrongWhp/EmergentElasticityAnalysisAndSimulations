for data_ind = maps_to_do
    
    thetas(:, data_ind) = rate_map_mega_struct.neighbor_posits{data_ind}.theta(2:7);
    r_posits(:, data_ind)  = rate_map_mega_struct.neighbor_posits{data_ind}.r(2:7);
    
    cur_thetas = rate_map_mega_struct.neighbor_posits{data_ind}.theta(2:7);
    cur_rs = rate_map_mega_struct.neighbor_posits{data_ind}.r(2:7);
    
    shifted_thetas = cur_thetas - pi/6;
    [~, arg_min] = min(abs(shifted_thetas));
    min_thetas(data_ind) = shifted_thetas(arg_min);
    
    
    mod_cur_thetas = sort(mod(cur_thetas, 2*pi));
    mod_shift_1 = sort(mod(mod_cur_thetas + pi/3, 2* pi));
    mod_shift_2 = sort(mod(mod_cur_thetas + 2 * pi/3, 2* pi));
    
    
    total_not_hexagon(data_ind)  = sum(abs(mod_cur_thetas - mod_shift_1) + abs(mod_cur_thetas - mod_shift_2) + abs(mod_shift_1 - mod_shift_2));
    mean_r(data_ind)  = mean(cur_rs);
    
end


close all

[neighbor_x neighbor_y] = pol2cart(thetas(:), r_posits(:));
hold on;
plot([0 0], [max(neighbor_y) min(neighbor_y)], 'k');
plot([max(neighbor_x) min(neighbor_x)], [0 0], 'k');

scatter(neighbor_x, neighbor_y, '*');
saveas(1, sprintf('%s/PeaksScatter.png', ap.output_path));
close all;