



for iY = 1:sysparams.array_height
   for iX = 1:sysparams.array_width
       for cond = 1:8
          hopeful_cond_times_visisted(iY, iX, cond) = sum(sum(system.cond_rh_accum(iY, iX, :, :, cond)));                     
       end   
   end
    
end

fprintf('Max diff is %f \n', max(max(max((hopeful_cond_times_visisted - system.cond_times_visited(:, :, 1:8) )))));

fprintf('Min diff is %f \n', min(min(min((hopeful_cond_times_visisted - system.cond_times_visited(:, :, 1:8) )))));



for iY = 1:sysparams.array_height
   for iX = 1:sysparams.array_width

          hopeful_times_visisted(iY, iX) = sum(sum(system.rh_accum_array(iY, iX, :, :)));                     
       
   end
end

fprintf('Max diff is %f \n', max(max(max((hopeful_times_visisted - system.times_visited_array )))));
fprintf('Min diff is %f \n', min(min(min((hopeful_times_visisted - system.times_visited_array )))));
