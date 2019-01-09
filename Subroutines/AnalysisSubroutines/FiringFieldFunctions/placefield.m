function [nFields,fieldProp,fieldBins,comXvec,comYvec,avgRate,peakRate,FFsize] = placefield(SmoothMap,lowestFieldRate,fieldThreshold, minNumBins, colAxis,rowAxis)

% This function takes the smoothed rate map in addition to some parameters
% for determining what is or isn't a field (e.g. field threshold, minimum
% number of bins that must be in a field, etc), and finds the firing
% fields. Essentially, this amounts to finding neighboring bins that are
% all above the field threshold. 


if length(colAxis) < 2 || length(rowAxis) < 2
    nFields = 0;
    fieldProp = [];
    fieldBins = [];
    return
end

binWidth = rowAxis(2) - rowAxis(1);

% Counter for the number of fields
nFields = 0;
% Field properties will be stored in this struct array
fieldProp = [];

% Holds the bin numbers
% 1: row bins
% 2: col bins
fieldBins = cell(100,2);

% Allocate memory to the arrays
[numRow,numCol] = size(SmoothMap);

% Array that contain the bins of the SmoothMap this algorithm has visited
visited = zeros(numRow,numCol);
nanInd = isnan(SmoothMap);
visited(nanInd) = 1;

globalPeak = nanmax(nanmax(SmoothMap));

%visited(SmoothMap<globalPeak*fieldThreshold) = 1;
visited(SmoothMap<fieldThreshold) = 1;

zeroMap = visited;

count = 0;

% Go as long as there are unvisited parts of the SmoothSmoothMap left
while ~prod(prod(visited))
    visited2 = visited;
    
    % Find the current maximum
    [peak,r] = max(SmoothMap);
    [peak,pCol] = max(peak);
    
    % Check if peak rate is high enough
    if peak < lowestFieldRate
        break;
    end
    
    pCol = pCol(1);  
    pRow = r(pCol);
    
    binCounter = 1;
    binsRow = zeros(numRow*numCol,1);
    binsCol = zeros(numRow*numCol,1);
    
    % Array that will contain the bin positions to the current placefield
    binsRow(binCounter) = pRow;
    binsCol(binCounter) = pCol;
    
    
    %visited2(SmoothMap<fieldThreshold*peak) = 1;
    visited2(SmoothMap<fieldThreshold) = 1;
    numOne = sum(sum(visited2));
    
    current = 0;
    while current < binCounter

        current = current + 1;
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current)-1, binsCol(current), numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current)+1, binsCol(current), numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current), binsCol(current)-1, numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current), binsCol(current)+1, numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current)-1, binsCol(current)-1, numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current)+1, binsCol(current)+1, numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current)+1, binsCol(current)-1, numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current)-1, binsCol(current)+1, numRow, numCol);
        
    end
    
    binsRow = binsRow(1:binCounter);
    binsCol = binsCol(1:binCounter);
    
    
    if isempty(binsRow)
        binsRow = pRow;
        binsCol = pCol;
    end
    
    if length(binsRow) >= minNumBins % Minimum size of a placefield
        count = count + 1;
        nFields = nFields + 1;
        fieldBins{nFields,1} = binsRow;
        fieldBins{nFields,2} = binsCol;
        % Find centre of mass (com)
        comX = 0;
        comY = 0;
        % Total rate
        R = 0;
        invertedyAxis = fliplr(rowAxis);
        for ii = 1:length(binsRow)
            fprintf('Binsrow length is %d col is %d \n', length(binsRow), length(binsCol));
            fprintf('Binsrow max is %d col is %d \n', max(binsRow), max(binsCol));
            
            fprintf('ColAxis size is: \n');
            size(colAxis)
            R = R + SmoothMap(binsRow(ii),binsCol(ii));
            bc_ii_plus_one = binsCol(ii) + 1;
            bc_ii_plus_one = min(length(colAxis), bc_ii_plus_one);
            
            
            %Truncating because if game an overflow. Not sure why.
            br_ii_plus_one = min(length(invertedyAxis), binsRow(ii) + 1);
            comY = comY + SmoothMap(binsRow(ii),binsCol(ii)) * (invertedyAxis(binsRow(ii))+invertedyAxis(br_ii_plus_one))/2; 
            comX = comX + SmoothMap(binsRow(ii),binsCol(ii)) * (colAxis(binsCol(ii))+colAxis(bc_ii_plus_one))/2;
        end
        % Average rate in field
        avgRate(count) = nanmean(nanmean(SmoothMap(binsRow,binsCol)));
        % Peak rate in field
        peakRate(count) = nanmax(nanmax(SmoothMap(binsRow,binsCol)));
        % Size of field
        fieldSize = length(binsRow) * binWidth^2;
        % Put the field properties in the struct array
        fieldProp = [fieldProp; struct('x',comY/R,'y',comX/R,'avgRate',avgRate,'peakRate',peakRate,'size',fieldSize)];
        comXvec(count) = comX/R;
        comYvec(count) = comY/R;
        FFsize(count) = fieldSize;
        

    end
    
    visited(binsRow,binsCol) = 1;
    SmoothMap(visited == 1) = 0;
end

fieldBins = fieldBins(1:nFields,:);

