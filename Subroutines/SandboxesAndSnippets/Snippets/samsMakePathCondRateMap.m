function [smoothMap] = samsMakePathCondRateMap(posfile,spikefile,boxSize, cond_num)

load(posfile)
load(spikefile)
global fileName1

% load all p-values - this is just copied from gridnessScore8_1
pstruct

% Scale the coordinates using the shape information
minX = nanmin([posx; posx2]);
maxX = nanmax([posx; posx2]);
minY = nanmin([posy; posy2]);
maxY = nanmax([posy; posy2]);
xLength = maxX - minX; yLength = maxY - minY;
sLength = max([xLength, yLength]);
scale = boxSize / sLength;
posx = posx * scale;
posy = posy * scale;
posx2 = posx2 * scale;
posy2 = posy2 * scale;

% Calculate the speed of the rat, sample by sample
if p.lowSpeedThreshold > 0 || p.highSpeedThreshold > 0
    
    % Calculate the speed of the rat, sample by sample
    speed = speed2D(posx,posy,post);
    
    if p.lowSpeedThreshold > 0 && p.highSpeedThreshold > 0
        bad_speed_inds = find(speed < p.lowSpeedThreshold | speed > p.highSpeedThreshold);
    elseif p.lowSpeedThreshold > 0 && p.highSpeedThreshold == 0
        bad_speed_inds = find(speed < p.lowSpeedThreshold );
    else
        bad_speed_inds = find(speed > p.highSpeedThreshold );
    end
    
    
end



%%%SAM-We Also NaN out indices where the path history conditions weren't
%%%met.
SAM_path_conds_not_met_inds = samsCalculateCondIndices((posx + posx2)/2, (posy + posy2)/2, post, cond_num);
posx(SAM_path_conds_not_met_inds) = NaN;
posy(SAM_path_conds_not_met_inds) = NaN;
posx2(SAM_path_conds_not_met_inds) = NaN;
posy2(SAM_path_conds_not_met_inds) = NaN;


% Remove the segments that have to high or to low speed
posx(bad_speed_inds) = NaN;
posy(bad_speed_inds) = NaN;
if p.doHeadDirectionAnalysis
    posx2(bad_speed_inds) = NaN;
    posy2(bad_speed_inds) = NaN;
end








% Calculate the spike positions
%SAM-I use both positions, not sure why they weren't both used before.
[spkx,spky,~] = spikePos(cellTS, (posx + posx2)/2, (posy + posy2)/2,post);
%[spkx,spky,~] = spikePos(cellTS, posx, posy,post);

% Calculate the border coordinates
maxX = nanmax(posx);
maxY = nanmax(posy);
xStart = nanmin(posx);
yStart = nanmin(posy);
xLength = maxX - xStart + p.binWidth*2;
yLength = maxY - yStart + p.binWidth*2;
start = min([xStart,yStart]);
tLength = max([xLength,yLength]);

% Calculate the rate map
% [map, rawMap, xAxis, yAxis, timeMap] = rateMap(posx,posy,spkx,spky,p.binWidth,p.binWidth,start,tLength,start,tLength,p.sampleTime, p);


% Calculate rate map with adaptive smoothing - what people normally use
shape = 1;
[smoothMap, posPDF, aRowAxis, aColAxis]  = ratemapAdaptiveSmoothing(posx, posy, spkx, spky, xStart, xLength-10, yStart, yLength-10, p.sampleTime, p, shape);



return