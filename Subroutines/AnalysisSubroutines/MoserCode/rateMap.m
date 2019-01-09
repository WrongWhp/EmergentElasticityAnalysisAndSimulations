function [map, rawMap, xAxis, yAxis, timeMap] = rateMap(posx,posy,spkx,spky,xBinWidth,yBinWidth,xStart,xLength,yStart,yLength,sampleTime,p)

% Number of bins in each direction of the map
numBinsX = ceil(xLength/xBinWidth);
numBinsY = ceil(yLength/yBinWidth);

% Allocate memory for the maps
spikeMap = zeros(numBinsY,numBinsX);
timeMap = zeros(numBinsY,numBinsX);

xAxis = zeros(numBinsX,1);
yAxis = zeros(numBinsY,1);

startPosX = xStart;
stopPosX = startPosX + xBinWidth;

for ii = 1:numBinsX
    
    % Find spikes and position samples that falls within the current bin in
    % the x-direction
    binSpkx = find(spkx>=startPosX & spkx<stopPosX);
    binTimex = find(posx>=startPosX & posx<stopPosX);
    
    startPosY = yStart;
    stopPosY = startPosY + yBinWidth;
    
    for jj = 1:numBinsY
        % Find spikes and position samples that falls within the current
        % bin
        binSpky = find(spky(binSpkx)>=startPosY & spky(binSpkx)<stopPosY);
        binTimey = find(posy(binTimex)>=startPosY & posy(binTimex)<stopPosY);
        
        % Add the number of spikes in the current bin
        spikeMap(numBinsY-jj+1,ii) = length(binSpky);
        % Add the number of position samples in the current bin
        timeMap(numBinsY-jj+1,ii) = length(binTimey);
        
        % Increment the y-coordinate for the position
        startPosY = startPosY + yBinWidth;
        stopPosY = stopPosY + yBinWidth;
    end
    
    % Increment the x-coordinate for the position
    startPosX = startPosX + xBinWidth;
    stopPosX = stopPosX + xBinWidth;
end

% Transform the number of spikes to time
timeMap = timeMap * sampleTime;

rawMap = spikeMap ./ timeMap;
rawMap(timeMap < p.minBinTime) = NaN;

if p.smoothingMode == 0
    % Smooth the spike and time map
    spikeMap = boxcarSmoothing(spikeMap);
    timeMap = boxcarSmoothing(timeMap);
else
    % Smooth the spike and time map
    spikeMap = boxcarSmoothing3x3(spikeMap);
    timeMap = boxcarSmoothing3x3(timeMap);
end


% Calculate the smoothed rate map
map = spikeMap ./ timeMap;

map(timeMap<p.minBinTime) = NaN;

% Set the axis
start = xStart + xBinWidth/2;
for ii = 1:numBinsX
    xAxis(ii) = start + (ii-1) * xBinWidth;
end
start = yStart + yBinWidth/2;
for ii = 1:numBinsY
    yAxis(ii) = start + (ii-1) * yBinWidth;
end


% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing(map)

% Load the box template
box = boxcarTemplate2D();

% Using pos and phase naming for the bins originate from the first use of
% this function.
[numPhaseBins,numPosBins] = size(map);

sMap = zeros(numPhaseBins,numPosBins);

for ii = 1:numPhaseBins
    for jj = 1:numPosBins
        for k = 1:5
            % Phase index shift
            sii = k-3;
            % Phase index
            phaseInd = ii+sii;
            % Boundary check
            if phaseInd<1
                phaseInd = 1;
            end
            if phaseInd>numPhaseBins
                phaseInd = numPhaseBins;
            end
            
            for l = 1:5
                % Position index shift
                sjj = l-3;
                % Position index
                posInd = jj+sjj;
                % Boundary check
                if posInd<1
                    posInd = 1;
                end
                if posInd>numPosBins
                    posInd = numPosBins;
                end
                % Add to the smoothed rate for this bin
                sMap(ii,jj) = sMap(ii,jj) + map(phaseInd,posInd) * box(k,l);
            end
        end
    end
end


% Gaussian boxcar template 5 x 5
function box = boxcarTemplate2D()

% Gaussian boxcar template
box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0200 0.1000 0.1600 0.1000 0.0200;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0025 0.0125 0.0200 0.0125 0.0025;];


   
   
   
% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing3x3(map)

% Load the box template
box = boxcarTemplate2D3by3();

% Using pos and phase naming for the bins originate from the first use of
% this function.
[numPhaseBins,numPosBins] = size(map);

sMap = zeros(numPhaseBins,numPosBins);

for ii = 1:numPhaseBins
    for jj = 1:numPosBins
        for k = 1:3
            % Phase index shift
            sii = k-1;
            % Phase index
            phaseInd = ii+sii;
            % Boundary check
            if phaseInd<1
                phaseInd = 1;
            end
            if phaseInd>numPhaseBins
                phaseInd = numPhaseBins;
            end
            
            for l = 1:3
                % Position index shift
                sjj = l-1;
                % Position index
                posInd = jj+sjj;
                % Boundary check
                if posInd<1
                    posInd = 1;
                end
                if posInd>numPosBins
                    posInd = numPosBins;
                end
                % Add to the smoothed rate for this bin
                sMap(ii,jj) = sMap(ii,jj) + map(phaseInd,posInd) * box(k,l);
            end
        end
    end
end
   
   
   
% Gaussian boxcar template 3 x 3
function box = boxcarTemplate2D3by3()

box = [0.075, 0.125, 0.075;...
       0.125, 0.200, 0.125;...
       0.075, 0.125, 0.075];

   
   
   
% Smooths the map with guassian smoothing
function sMap = mapSmoothing(map)

box = boxcarTemplate1D();

numBins = length(map);
sMap = zeros(1,numBins);

for ii = 1:numBins
    for k = 1:5
        % Bin shift
        sii = k-3;
        % Bin index
        binInd = ii + sii;
        % Boundry check
        if binInd<1
            binInd = 1;
        end
        if binInd > numBins
            binInd = numBins;
        end
        
        sMap(ii) = sMap(ii) + map(binInd) * box(k);
    end
end

% 1-D Gaussian boxcar template 5 bins
function box = boxcarTemplate1D()

% Gaussian boxcar template
box = [0.05 0.25 0.40 0.25 0.05];

