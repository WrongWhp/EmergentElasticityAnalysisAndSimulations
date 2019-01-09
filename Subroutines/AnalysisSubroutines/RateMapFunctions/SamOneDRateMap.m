function [rm_struct] = SamOneDRateMap(posx,fr, track_start, track_end)


%Modified from the 2D Ratemap code

% this assumes that posx and posy were already scaled to have appropriate
% max and min. also take 'fr' variable, which is just the number of spikes
% that occurred in every 20 ms time bin

numBins = round((track_end - track_start)/2.);


xAxis = linspace(track_start,track_end,numBins+1);
%yAxis = xAxis;

% initialize rate map
rateMap = zeros(numBins,1);
rm_struct.mouse_count = zeros(numBins,1);
rm_struct.spike_count = zeros(numBins,1);
rm_struct.x_values = zeros(numBins,1);



% find the mean firing rate in each position bin
for iX  = 1:numBins
    start_x = xAxis(iX); stop_x = xAxis(iX+1);
    % find the times the animal was in the bin
    if iX == numBins
        x_ind = find(posx >= start_x & posx <= stop_x);
    else
        x_ind = find(posx >= start_x & posx < stop_x);
    end
    
    
    
    inside_bin_inds = x_ind;%Only x matters
    inside_bin_and_cond_met_inds = inside_bin_inds;
    rateMap(iX) = nanmean(fr(inside_bin_and_cond_met_inds));
    rm_struct.mouse_count(iX) = length(inside_bin_and_cond_met_inds);
    rm_struct.spike_count(iX) = nansum(fr(inside_bin_and_cond_met_inds));
    rm_struct.x_values(iX) = .5 * (start_x + stop_x);
end



smoothing_filter = fspecial('gaussian', [15 1], 3);

%smoothing_filter =  [0.0200 0.1000 0.1600 0.1000 0.0200]';
rm_struct.smoothed_spike_count = imfilter(rm_struct.spike_count, smoothing_filter);
rm_struct.smoothed_mouse_count = imfilter(rm_struct.mouse_count, smoothing_filter);
rm_struct.smoothed_firing_rate = rm_struct.smoothed_spike_count./rm_struct.smoothed_mouse_count;

rm_struct.purely_binned_rate = rm_struct.spike_count./rm_struct.mouse_count;


