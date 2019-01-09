



rate_maps_used = 0;
for i = 1:length(all_rate_maps)
   cur_rate_map = all_rate_maps{i};
   
   norm_rate_map = cur_rate_map/mean(cur_rate_map(:));       
   
   if(size(cur_rate_map, 1) == size(cum_rate_map, 1) && size(cur_rate_map,2) == size(cum_rate_map, 2))
        rate_maps_used   = rate_maps_used + 1;

       rate_map_cube(:, :, rate_maps_used) = norm_rate_map;

   end
    
end


backup_rate_map_cube = rate_map_cube;
rand_perm = randperm(length(rate_map_cube(:)));
unraveled_shuffle =  backup_rate_map_cube(rand_perm);

%rate_map_cube(:) =  unraveled_shuffle;
%rate_map_cube = randn(size(rate_map_cube)) > 1.3;

mean_rate_map = mean(rate_map_cube, 3);

rate_map_std = std(rate_map_cube, 0, 3)/sqrt(size(rate_map_cube, 3));

fprintf('%d Maps used, Max is %f, min is %f \n', rate_maps_used, max(cum_rate_map(:)), min(cum_rate_map(:)));


imagesc(mean_rate_map );
colormap jet
colorbar
saveas(1, 'Output/zMeanRateMap.png');


imagesc(rate_map_std);
colormap jet
colorbar
saveas(1, 'Output/zRateMapSTD.png');




mean_rate_to_std_ratio = (mean_rate_map - mean(mean_rate_map(:)))./rate_map_std;

imagesc(mean_rate_to_std_ratio);
colormap jet
colorbar
saveas(1, 'Output/zRateMapRatio.png');


hist(mean_rate_to_std_ratio(:));
saveas(1, 'Output/zRateMapRatioDist.png');

