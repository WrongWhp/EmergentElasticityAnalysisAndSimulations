% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing(map)

% Gaussian boxcar template
box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0200 0.1000 0.1600 0.1000 0.0200;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0025 0.0125 0.0200 0.0125 0.0025;];

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
return