



rate_maps_used = 0;


for i = 1:length(all_rate_maps)
   cur_mouse_count = all_mouse_counts{i};
   cur_spike_count = all_spike_counts{i};
   
   
   norm_mouse_count = cur_mouse_count/mean(cur_mouse_count(:));
   norm_spike_count = cur_spike_count/mean(cur_spike_count(:));
   cur_spike_rate  = norm_spike_count./norm_mouse_count;
   
   mouse_count_cube(:, :, i) = norm_mouse_count;
   spike_count_cube(:, :, i) = norm_spike_count;
   rate_map_cube(:, :, i) = cur_spike_rate;
    
    
end



mean_mouse_count = mean(mouse_count_cube, 3);
mean_spike_count = mean(spike_count_cube, 3);

backup_rate_map_cube = rate_map_cube;
rand_perm = randperm(length(rate_map_cube(:)));
unraveled_shuffle =  backup_rate_map_cube(rand_perm);

rate_map_cube(:) =  unraveled_shuffle;


added_then_divided_rate = mean_spike_count./mean_mouse_count;


imagesc(added_then_divided_rate);
colormap jet
colorbar
saveas(1, 'Output/zMeanRateMapSam-AddedThenDivided.png');



for i = 1:size(rate_map_cube, 1)
   for j = 1:size(rate_map_cube, 2)
        %We dont want the nans to count
        rates_to_average = rate_map_cube(i, j, :);
        rates_to_average = rates_to_average(~isnan(rates_to_average));
        mean_rate_map(i, j) = mean(rates_to_average(:));
        rate_map_std(i, j) = std(rates_to_average(:))/sqrt(length(rates_to_average(:)));
       
        
   end    
end


fprintf('%d Maps used, Max is %f, min is %f \n', rate_maps_used, max(cum_rate_map(:)), min(cum_rate_map(:)));


hist(mean_rate_map(:));
saveas(1, 'Output/zHistMeanRateMapHist.png');



imagesc(mean_rate_map);
colormap jet
colorbar
saveas(1, 'Output/zMeanRateMapSam.png');


imagesc(rate_map_std);
colormap jet
colorbar
saveas(1, 'Output/zRateMapSTDSam.png');




mean_rate_to_std_ratio = (mean_rate_map - mean(mean_rate_map(:)))./rate_map_std;

imagesc(mean_rate_to_std_ratio);
colormap jet
colorbar
saveas(1, 'Output/zRateMapRatioSam.png');


hist(mean_rate_to_std_ratio(:));
saveas(1, 'Output/zRateMapRatioDistSam.png');


