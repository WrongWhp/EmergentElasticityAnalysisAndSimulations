function [x_corr, delta_x, delta_y] = XCorrWithDeltas(m1, m2);

x_corr = xcorr2(m1, m2);
delta_x = (1:size(x_corr, 2)) - mean(1:size(x_corr, 2));
delta_y  = (1:size(x_corr, 1)) - mean(1:size(x_corr, 1));;