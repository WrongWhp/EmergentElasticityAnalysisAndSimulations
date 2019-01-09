tic

binned_indices = SortIndicesByBin(traj.posx, traj.posy);

toc


tic

foo = ComputeRateMapFromBinnedIndices(binned_indices, fr, 1:length(traj.posx));

toc


tic

bar = KiahComputeRateMap(traj.posx, traj.posy, fr, 1:length(traj.posx));

toc