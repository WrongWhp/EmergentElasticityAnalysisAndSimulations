hd_hist_accum = zeros([1 20]);

for data_ind = 1:length(all_data)
    traj = all_data{data_ind}.traj;
    foo = histcounts(cart2pol(traj.hd_x, traj.hd_y), 20);
    %hist(cart2pol(traj.hd_x, traj.hd_y), 20);
%    hist(abs(traj.hd_x));
   % scatter(traj.hd_x, traj.hd_y);
   hd_hist_accum = hd_hist_accum + foo;
%    pause;
end