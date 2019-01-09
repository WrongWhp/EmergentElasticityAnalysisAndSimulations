function [binned_indices dist_from_center] = AverageOffsetForCond(traj, cond)

posx = traj.posx;
posy = traj.posy;
cond_met_indices = pathConditionSwitchboard(traj, cond);


%Takes posx, posy, and decides which indices corrspond to which bin.


% this assumes that posx and posy were already scaled to have appropriate
% max and min. also take 'fr' variable, which is just the number of spikes
% that occurred

% use 20 bins, no matter the size of the environment
numBins = 5+1;
xAxis = linspace(nanmin(posx),nanmax(posx),numBins);
yAxis = linspace(nanmin(posy), nanmax(posy), numBins);
%fprintf('Mean diff is %f \n', mean(diff(xAxis)));

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



y_bin_size = mean(diff(yAxis));
x_bin_size = mean(diff(xAxis)); 
cond_met = zeros(size(posx));
cond_met(cond_met_indices) = 1;

for iX  = 1:numBins-1
    for iY = 1:numBins-1        
        inside_bin_inds = intersect(x_inds{iX},y_inds{iY});  
        inside_bin_inds = inside_bin_inds(cond_met(inside_bin_inds) == 1); % Just a hack to get this working
        
        binned_indices{iY}{iX} = inside_bin_inds;
        dist_from_center.y(iY,iX) = mean(posy(inside_bin_inds) - yAxis(iY) - .5 * y_bin_size);
        dist_from_center.x(iY,iX) = mean(posx(inside_bin_inds) - xAxis(iX) - .5 * x_bin_size);
        
    end
end






