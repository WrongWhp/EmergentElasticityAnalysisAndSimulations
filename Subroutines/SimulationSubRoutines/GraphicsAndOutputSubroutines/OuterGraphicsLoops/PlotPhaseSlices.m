function [] = PlotPhaseSlices(system, z_accum_array)

close all

iY_range = min(system.mesh.iY(system.in_bounds)) : max(system.mesh.iY(system.in_bounds));

phase_relative_to_right = false;

offset_mult = .3;

for iY = iY_range
   z_accum_slice = z_accum_array(iY, :);
   in_bounds_slice = system.in_bounds(iY, :);
   
   prettified_phase_array = PrettifiedPhaseArray(z_accum_slice, in_bounds_slice);
   if(phase_relative_to_right)
      %Sometimes it's easier to look at it when it's relative to the right
      %side. We can do this when the right side isn't deformed but the left
      %side is
      prettified_phase_array = prettified_phase_array - prettified_phase_array(length(prettified_phase_array));
       
   end
   x_coords_for_slice = system.x_array(in_bounds_slice);
   
   plot(x_coords_for_slice, prettified_phase_array - 1 * iY * offset_mult );
   hold on;
   
   
    
end



