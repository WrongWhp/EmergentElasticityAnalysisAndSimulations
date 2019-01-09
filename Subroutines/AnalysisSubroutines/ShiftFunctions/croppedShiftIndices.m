function [shift_inds] = croppedShiftIndices( y_indices, x_indices,  shift_struct);

shift_inds.iX = x_indices + shift_struct.iX;
shift_inds.iY = y_indices + shift_struct.iY;

