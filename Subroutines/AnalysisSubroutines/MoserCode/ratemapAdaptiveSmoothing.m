function [map, posPdf, rowAxis, colAxis] = ratemapAdaptiveSmoothing(posx, posy, spkx, spky, xStart, xLength, yStart, yLength, sampleTime, p, shape)



% Number of bins in each direction of the map
numColBins = ceil(xLength/p.binWidth);
numRowBins = ceil(yLength/p.binWidth);

rowAxis = zeros(numRowBins,1);
for ii = 1:numRowBins
    rowAxis(numRowBins-ii+1) = yStart+p.binWidth/2+(ii-1)*p.binWidth;
end
colAxis = zeros(numColBins, 1);
for ii = 1:numColBins
    colAxis(ii) = xStart+p.binWidth/2+(ii-1)*p.binWidth;
end

maxBins = max([numColBins, numRowBins]);

map = zeros(numRowBins, numColBins);
posPdf = zeros(numRowBins, numColBins);


binPosX = (xStart+p.binWidth/2);

if shape(1) == 1
    for ii = 1:numColBins

        binPosY = (yStart + p.binWidth/2);
        
        for jj = 1:numRowBins

            radius = maxBins * p.binWidth;
            % Number of samples inside the circle
            n = insideCircle(binPosX, binPosY, radius, posx, posy);
            % Number of spikes inside the circle
            s = insideCircle(binPosX, binPosY, radius, spkx, spky);

            if maxBins > p.alphaValue/(n*sqrt(s))         
                
                n = 0;
                s = 0;
                for r = 1:maxBins
                    % Set the current radius of the circle
                    radius = r * p.binWidth;
                    % Number of samples inside the circle
                    n = insideCircle(binPosX, binPosY, radius, posx, posy);
                    % Number of spikes inside the circle
                    s = insideCircle(binPosX, binPosY, radius, spkx, spky);

                    if r >= p.alphaValue/(n*sqrt(s))         
                        break;
                    end

                end
            end
            
            
            % Set the rate for this bin
            map(numRowBins-jj+1,ii) = s/(n*sampleTime);
            posPdf(numRowBins-jj+1,ii) = n*sampleTime;
            binPosY = binPosY + p.binWidth;
        end 

        binPosX = binPosX + p.binWidth;
    end

else
    for ii = 1:numColBins

        binPosY = (yStart + p.binWidth/2);
        for jj = 1:numRowBins
            currentPosition = sqrt(binPosX^2 + binPosY^2);
            if currentPosition > shape(2)/2
                map(numRowBins-jj+1,ii) = NaN;
                posPdf(numRowBins-jj+1,ii) = NaN;
            else
                n = 0;
                s = 0;
                for r = 1:maxBins
                    % Set the current radius of the circle
                    radius = r * p.binWidth;
                    % Number of samples inside the circle
                    n = insideCircle(binPosX, binPosY, radius, posx, posy);
                    % Number of spikes inside the circle
                    s = insideCircle(binPosX, binPosY, radius, spkx, spky);

                    if r >= p.alphaValue/(n*sqrt(s))         
                        break;
                    end

                end
                % Set the rate for this bin
                map(numRowBins-jj+1,ii) = s/(n*sampleTime);
                posPdf(numRowBins-jj+1,ii) = n*sampleTime;
                
            end
            binPosY = binPosY + p.binWidth;
        end 

        binPosX = binPosX + p.binWidth;
    end
end

map(posPdf<0.100) = NaN;
posPdf = posPdf / nansum(nansum(posPdf));



% Calculate how many points lies inside the circle
%
% cx        X-coordinate for the circle centre
% cy        Y-coordinate for the circle centre
% radius    Radius for the circle
% pointX    X-coordinate(s) for the point(s) to check
% pointY    Y-coordinate(s) for the point(s) to check
function n = insideCircle(cx, cy, radius, pointX, pointY)

dist = sqrt((pointX-cx).^2 + (pointY-cy).^2);
n = length(dist(dist <= radius));