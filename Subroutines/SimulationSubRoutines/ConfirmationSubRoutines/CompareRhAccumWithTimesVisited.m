


%Makes sure that the times visited is consistent with the logging of the
%times visited.

for iY = 1:sysparams.array_height
    for iX = 1:sysparams.array_width
        cur_posit_rh_dist = prev_rh_accum(iY, iX, :, :);
        my_other_count(iY, iX) = sum(cur_posit_rh_dist(:));
        
    end
end

scatter(prev_times_visited(:), my_other_count(:));
%prev_rh_accum
