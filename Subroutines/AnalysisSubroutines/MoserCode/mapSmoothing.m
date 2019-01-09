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