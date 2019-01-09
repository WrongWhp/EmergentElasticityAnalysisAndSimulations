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
return