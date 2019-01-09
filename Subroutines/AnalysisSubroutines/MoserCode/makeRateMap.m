function [smoothMap] = makeRateMap(posfile,spikefile,boxSize)

load(posfile)
load(spikefile)
global fileName1

% load all p-values - this is just copied from gridnessScore8_1
pstruct

% Scale the coordinates using the shape information   
minX = nanmin(posx); 
maxX = nanmax(posx);
minY = nanmin(posy); 
maxY = nanmax(posy);
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
        ind = find(speed < p.lowSpeedThreshold | speed > p.highSpeedThreshold);
    elseif p.lowSpeedThreshold > 0 && p.highSpeedThreshold == 0
        ind = find(speed < p.lowSpeedThreshold );
    else
        ind = find(speed > p.highSpeedThreshold );
    end
    
    % Remove the segments that have to high or to low speed
    posx(ind) = NaN;
    posy(ind) = NaN;
    if p.doHeadDirectionAnalysis
        posx2(ind) = NaN;
        posy2(ind) = NaN;
    end
end


% Calculate the spike positions
[spkx,spky,~] = spikePos(cellTS,posx,posy,post);

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