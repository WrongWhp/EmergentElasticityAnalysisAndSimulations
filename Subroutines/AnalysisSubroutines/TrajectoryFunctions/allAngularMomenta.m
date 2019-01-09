

for data_ind = 1:length(rate_map_mega_struct.trajectories)
   traj = rate_map_mega_struct.trajectories{data_ind};
   angular_momentum_list(data_ind) = angularMomentum(traj);
   head_vel_corr_list(data_ind) = headVelocityCorr(traj);
end

unique_list = unique(angular_momentum_list);

