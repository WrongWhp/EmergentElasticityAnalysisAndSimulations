foo = zeros(11, 12, 13, 14);
size(permute(foo, [4 2 3 1] ))



foo = zeros(2, 2);
size(permute(foo, [3 4 1 2]))


%% Was at end


imshow(.5 * system.in_bounds + .5 * (system.times_visited_array> 0));
hold on;
plot(path.iX, path.iY)


print(sprintf('%s/PathAndVisiting', sysparams.folder_path), '-dpng')

close all

mean_z_array = system.z_accum_array ./ system.times_visited_array;




imwrite(real(mean_z_array), sprintf('%s/StripePattern.png', sysparams.folder_path))

imwrite(real(mean_z_array), sprintf('%s/Boundary.png', sysparams.folder_path))

close all;
