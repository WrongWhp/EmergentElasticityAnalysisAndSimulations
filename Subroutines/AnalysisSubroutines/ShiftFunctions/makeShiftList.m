%For now, the shifts to do are indexed a little differently. The first
%index is (EW, NS), and then the second determines the sign.

ap.sm = 1;

shifts_to_do{1}= struct('iX', ap.sm, 'iY', 0, 'name', 'Map East Shifted 1', 'axis', 'EW');
shifts_to_do{2} = struct('iX',-ap.sm, 'iY', 0, 'name', 'Map West Shifted 1', 'axis', 'EW');

shifts_to_do{3} = struct('iX', 0, 'iY', ap.sm, 'name', 'Map North Shifted 1', 'axis', 'NS');
shifts_to_do{4} = struct('iX', 0, 'iY',-ap.sm, 'name', 'Map South Shifted 1', 'axis', 'NS');

opp_shift_pairs{1} = {1 2};
opp_shift_pairs{2} = {3 4};



shift_range = ceil(round(2 * (rate_map_mega_struct.n_bins/20)));

zero_shift_struct = struct('iX', 0, 'iY', 0, 'name', 'ZEROSHIFTNAME', 'axis', 'ZEROSHIFTAXIS');
shifts_to_do{length(shifts_to_do) + 1} = zero_shift_struct;

for iX  = -shift_range:shift_range
   for iY = -shift_range:shift_range
       proposed_shift = struct('iX', iX, 'iY', iY, 'name', 'SHOULDNTNEEDTHISNAME', 'axis', 'SHOULDNTNEEDTHISAXIS');
       if(~containsShiftVec(shifts_to_do, proposed_shift))
           shifts_to_do{length(shifts_to_do) + 1} = proposed_shift;
       end
   end
end






