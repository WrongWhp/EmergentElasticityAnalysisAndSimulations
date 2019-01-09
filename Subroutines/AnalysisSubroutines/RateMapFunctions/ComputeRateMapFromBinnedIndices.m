function [rateMap, rm_struct] = ComputeRateMapFromBinnedIndices(binned_indices,fr, cond_met_inds)

% this assumes that posx and posy were already scaled to have appropriate
% max and min. also take 'fr' variable, which is just the number of spikes
% that occurred in every 20 ms time bin

% use 20 bins, no matter the size of the environment
global ap;
numBins = ap.n_bins+1;


% initialize rate map
rateMap = zeros(numBins-1,numBins-1);
rm_struct.mouse_count = zeros(numBins-1,numBins-1);
rm_struct.spike_count = zeros(numBins-1,numBins-1);
rm_struct.streak_count = zeros(numBins-1,numBins-1);



cond_met_array = zeros(size(fr)); %I do this as a trick to avoid having to use the intersect function for each bin.
cond_met_array(cond_met_inds) = 1;

% find the mean firing rate in each position bin
for iX  = 1:numBins-1
    for iY = 1:numBins-1
        
        inside_bin_inds = binned_indices{iY}{iX};
 %       inside_bin_and_cond_met_inds = intersect(inside_bin_inds, cond_met_inds);
        inside_bin_and_cond_met_inds = inside_bin_inds(cond_met_array(inside_bin_inds) > 0);
        
        
%        fprintf('Sizes are %d %d %d \n', length(inside_bin_and_cond_met_inds), length(inside_bin_and_cond_met_inds_1), length(intersect(inside_bin_and_cond_met_inds, inside_bin_and_cond_met_inds_1)));
        % fill in rate map
        
        rateMap(iY,iX) = nanmean(fr(inside_bin_and_cond_met_inds));
        rm_struct.mouse_count(iY,iX) = length(inside_bin_and_cond_met_inds);
        rm_struct.spike_count(iY,iX) = nansum(fr(inside_bin_and_cond_met_inds));
        %Number of times it leaves the box and doesn't come back in for another 5 seconds
        rm_struct.streak_count(iY,iX) = sum(diff(inside_bin_and_cond_met_inds) > (5./.02)) +  double(length(inside_bin_and_cond_met_inds)>0);
    end
end




rm_struct.purely_binned_rate = rm_struct.spike_count./rm_struct.mouse_count;
rm_struct.dummy_binned_rate = rm_struct.purely_binned_rate;




if(1)
    stens_smooth_filter = ...
        [0.0025 0.0125 0.0200 0.0125 0.0025;...
        0.0125 0.0625 0.1000 0.0625 0.0125;...
        0.0200 0.1000 0.1600 0.1000 0.0200;...
        0.0125 0.0625 0.1000 0.0625 0.0125;...
        0.0025 0.0125 0.0200 0.0125 0.0025];
    
    
    rm_struct.stens_mouse_count = imfilter(rm_struct.mouse_count, stens_smooth_filter, 0);
    rm_struct.stens_spike_count = imfilter(rm_struct.spike_count, stens_smooth_filter, 0);
    rm_struct.stens_firing_rate = rm_struct.stens_spike_count./rm_struct.stens_mouse_count;
end
rateMap = 0;


rm_struct.cm_smoothed_rate = CenterOfMassSmoothing(rm_struct.mouse_count, rm_struct.spike_count);


return