
function [dist_im] = RhDistImage(rh_dist_array)

%Plots a set of weights W(phi_u, phi_v). We transform it because the
%distrubtion of thhese weights are over the periodic rhombus (Twisted
%Torus)

im_to_show = rh_dist_array;
im_to_show = im_to_show/max(im_to_show(:));
im_to_show = imresizeWithLines(im_to_show, 40, [.6 .6 0]);
%    im_to_show = imresize(im_to_show, 20, 'nearest');



rh_tform_mat = [1 0 0; .5 sqrt(3)/2. 0; 0 0 1];
tform = maketform('affine', rh_tform_mat);
transformed_image = imtransform( im_to_show, tform, 'nearest','FillValues', [0; 0; .5]);

dist_im = transformed_image;