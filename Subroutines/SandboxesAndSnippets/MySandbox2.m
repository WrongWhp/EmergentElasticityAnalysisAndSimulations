

for stripe_phase_shift = exp(2 * pi * j * (0:.25:.999))
    %    output_image = FiringRateImage(system, system.z_accum_array *stripe_phase_shift  ,  system.times_visited_array);
    output_image = FiringRateContourImage(system, system.z_accum_array *stripe_phase_shift  ,  system.times_visited_array);
    
    imwriteWithPath(output_image, sprintf('%s/ZFiring/Raw/Phase%f/Run%d.png', sysparams.folder_path, imag(log(stripe_phase_shift)), run_num));
    
    
    output_image = .5 + output_image;
    %imshow(output_image);
    
    contourf(flipud(output_image))
    daspect([1 1 1])
    
    saveas(1, 'foo.png');
    %colormap jet
    saveas(1, 'foo.pdf');
    
    imcontour(flipud(output_image), 'y');
    daspect([1 1 1])
    
    saveas(1, 'foofoo.pdf');
    
    imagesc(1 -output_image)
    
    saveas(1, 'foobar.pdf');
    imwrite(output_image, 'foooutputim.png');
    
    mask = zeros ( size(output_image));
    
    for bounds = .4:.1:1
        mask = mask + (abs(output_image - bounds ) < .01);
    end
    
    mask(isnan(mask)) = 0;
    rgb_output_im = gray2rgb(output_image);
    rgb_output_im = colorAllRegions(rgb_output_im, logical(mask), [1 1 0]);
    imwrite(rgb_output_im, 'outputwithcont.png');
end