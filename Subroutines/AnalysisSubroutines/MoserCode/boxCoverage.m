function coverage = boxCoverage(posx, posy, binWidth)


minX = nanmin(posx);
maxX = nanmax(posx);
minY = nanmin(posy);
maxY = nanmax(posy);

% Side lengths of the box
xLength = maxX - minX;
yLength = maxY - minY;

% Number of bins in each direction
colBins = ceil(xLength/binWidth);
rowBins = ceil(yLength/binWidth);

% Allocate memory for the coverage map
coverageMap = zeros(rowBins, colBins);
rowAxis = zeros(rowBins,1);
colAxis = zeros(colBins,1);

% Find start values that centre the map over the path
xMapSize = colBins * binWidth;
yMapSize = rowBins * binWidth;
xOff = xMapSize - xLength;
yOff = yMapSize - yLength;

xStart = minX - xOff / 2;
xStop = xStart + binWidth;

for r = 1:rowBins
    rowAxis(r) = (xStart + xStop) / 2;
    ind = find(posx >= xStart & posx < xStop);
    yStart = minY - yOff / 2;
    yStop = yStart + binWidth;
    for c = 1:colBins
        colAxis(c) = (yStart + yStop) / 2;
        coverageMap(r,c) = length(find(posy(ind) > yStart & posy(ind) < yStop));
        yStart = yStart + binWidth;
        yStop = yStop + binWidth;
    end
    xStart = xStart + binWidth;
    xStop = xStop + binWidth;
end

coverage = length(find(coverageMap > 0)) / (colBins*rowBins) * 100;

return

