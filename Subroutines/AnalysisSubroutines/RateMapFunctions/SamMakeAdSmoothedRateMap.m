%function [smoothMap posPDF, aRowAxis, aColAxis] = SamMakeAdSmoothedRateMap(posfile,spikefile,boxSize)




%load(posfile)
posx =  traj.posx;
posy = traj.posy;
post = traj.post;

load(spikefile)
global fileName1

% load all p-values - this is just copied from gridnessScore8_1
pstruct

% Scale the coordinates using the shape information
if(1)
    minX = nanmin(posx);
    maxX = nanmax(posx);
    minY = nanmin(posy);
    maxY = nanmax(posy);
    xLength = maxX - minX; yLength = maxY - minY;
    sLength = max([xLength, yLength]);
    scale = boxSize / sLength;
    posx = posx * scale;
    posy = posy * scale;
end

%fprintf('X range is %f %f \n', max(posx), min(posx));
%fprintf('Y range is %f %f \n', max(posy), min(posy));


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