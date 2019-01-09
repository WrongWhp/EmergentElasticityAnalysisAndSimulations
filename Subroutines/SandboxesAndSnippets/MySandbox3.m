

for stripe_phase_shift = exp(2 * pi * j * (0:.25:.999))
    %    output_image = FiringRateImage(system, system.z_accum_array *stripe_phase_shift  ,  system.times_visited_array);
    output_image = FiringRateContourImage(system, system.z_accum_array *stripe_phase_shift  ,  system.times_visited_array);
    imwrite(output_image, 'foobar.png');
end