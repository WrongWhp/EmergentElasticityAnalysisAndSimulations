function [firing_rates] = FiringCountFromRhSmoothed(rh_accum_array, vu_displacement)

%Converts the attractor network distribution into an observed firing rate

rh_graining= size(rh_accum_array, 3);

filter_radius = .2;
dist_to_use = circshift(ParabolaRhDist(rh_graining, filter_radius), round(vu_displacement * rh_graining));
%dist_to_use = dist_to_use/sum(dist_to_use(:));
dist_to_use = permute(dist_to_use, [3 4 1 2]);
%dist_to_use = dist_to_use/sum(dist_to_use(:));


for iY = 1:size(rh_accum_array, 1)
   for iX = 1:size(rh_accum_array, 2)
       prod_image = rh_accum_array(iY, iX, :, :) .* dist_to_use;
       
       
       %For each iX, iY, apply some sort of projection onto the rhombic distribution 
       
       firing_rates(iY, iX) = sum(prod_image(:));
       
   end
end



