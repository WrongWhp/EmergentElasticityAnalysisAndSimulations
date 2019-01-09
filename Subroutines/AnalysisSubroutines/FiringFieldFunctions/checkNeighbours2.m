function [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, cRow, cCol, numRow, numCol)

if cRow < 1 || cRow > numRow || cCol < 1 || cCol > numCol
    return
end

if visited2(cRow, cCol)
    % Bin has been checked before
    return
end

binCounter = binCounter + 1;
binsRow(binCounter) = cRow;
binsCol(binCounter) = cCol;
visited2(cRow, cCol) = 1;

