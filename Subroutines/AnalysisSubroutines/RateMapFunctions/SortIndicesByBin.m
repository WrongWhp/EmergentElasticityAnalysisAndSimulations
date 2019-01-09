function [binned_indices dist_from_center] = SortIndicesByBin(posx,posy)

%Takes posx, posy, and decides which indices corrspond to which bin.


% this assumes that posx and posy were already scaled to have appropriate
% max and min. also take 'fr' variable, which is just the number of spikes
% that occurred

% use 20 bins, no matter the size of the environment
global ap;
numBins = ap.n_bins + 1;

xAxis = linspace(nanmin(posx),nanmax(posx),numBins);
yAxis = linspace(nanmin(posy), nanmax(posy), numBins);

%yAxis = xAxis;


%Compute which inds fall within each iX, iY range.
for iY = 1:numBins -1
    start_y = yAxis(iY); stop_y = yAxis(iY+1);    
    if iY == numBins-1
        y_inds{iY} = find(posy >= start_y & posy <= stop_y);
    else
        y_inds{iY} = find(posy >= start_y & posy < stop_y);
    end
end

for iX = 1:numBins-1
        start_x = xAxis(iX); stop_x = xAxis(iX+1);        
        % find the times the animal was in the bin
        if iX == numBins-1
            x_inds{iX} = find(posx >= start_x & posx <= stop_x);
        else
            x_inds{iX} = find(posx >= start_x & posx < stop_x);
        end    
end

for iX  = 1:numBins-1
    for iY = 1:numBins-1        
        inside_bin_inds = intersect(x_inds{iX},y_inds{iY});  
        
        binned_indices{iY}{iX} = inside_bin_inds;
        
    end
end





