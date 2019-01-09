%% Makes a bunch of adaptively smoothed rate maps and then does cross correlation on them.

for data_ind = maps_to_do
    close all;
    fprintf('Doing CrossCorr for %d \n', data_ind);
    cur_data_path_struct = all_data_paths{data_ind};
    
    smoothed_rate_map = makeRateMap(cur_data_path_struct.pos_path, cur_data_path_struct.spike_path, 100);
    
%    plot_params.output_path = sprintf('%s/CrossCorr/Output%d(AddingPeakWidth).png', ap.output_path, data_ind);
    plot_params.title = strrep(all_data_paths{data_ind}.spike_path, '_', ' ');;
    plot_params.output_path = sprintf('%s/CrossCorr/%s_MapAndCorr.png', ap.output_path, all_data_paths{data_ind}.spike_path);
    
   [rate_map_mega_struct.cov_matrices{data_ind} rate_map_mega_struct.neighbor_posits{data_ind}] = CrossCorrAndShear(smoothed_rate_map, plot_params);
   eigs_of_cov_matrix = eig(rate_map_mega_struct.cov_matrices{data_ind});
   rate_map_mega_struct.sam_ellipticities(data_ind) = abs(log(eigs_of_cov_matrix(1) / eigs_of_cov_matrix(2)));    
end 