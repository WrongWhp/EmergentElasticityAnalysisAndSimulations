

fprintf('Outputting landmark cell firing fields, we have a total of %d landmark cells ...', length(landmark_cell_list));

for iT =1:length(landmark_cell_list)
    cur_landmark_cell = landmark_cell_list{iT};
    im_to_show = FiringRateImage(system, 2 * double(cur_landmark_cell.mask) - 1, ones(size(cur_landmark_cell.mask)));
%    im_to_show = imresize(.5 * system.is_inner_boundary + .5 * cur_landmark_cell.mask.* system.in_bounds, 5 * sysparams.spacing, 'nearest');
    imwriteWithPath(im_to_show, sprintf('%s/LandmarkCells/FiringFields/LandmarkCell%d.png', sysparams.folder_path, iT));
   % fprintf('Centers are x=%f, y=%f, Learned_z is %1.4g +  %1.4g j \n', cur_landmark_cell.x_center, cur_landmark_cell.y_center, real(cur_landmark_cell.learned_z), imag(cur_landmark_cell.learned_z));
end

fprintf('Finished! \n');
