function [rows, cols, visited] = checkNeighbours(SmoothMap, rows, cols, visited)


row = rows(1);
col = cols(1);

visited(row, col) = 0;

% Set indexes to the surounding bins
leftRow = row - 1;
rightRow = row + 1;
upRow = row;
downRow = row;

leftCol = col;
rightCol = col;
upCol = col - 1;
downCol = col + 1;


% Check left
if leftRow >= 1 % Inside map
    if visited(leftRow,leftCol) && map(leftRow,leftCol) <= map(row,col)
        % Add bin as part of the field
        rows = [rows; leftRow;];
        cols = [cols; leftCol];
        visited(leftRow, leftCol) = 0;
    end
end
% Check rigth
if rightRow <= size(map,2) % Inside map
    if visited(rightRow,rightCol) && map(rightRow,rightCol) <= map(row,col)
        % Add bin as part of the field
        rows = [rows; rightRow];
        cols = [cols; rightCol];
        visited(rightRow, rightCol) = 0;
    end
end
% Check up
if upCol >= 1 % Inside map
    if visited(upRow,upCol) && map(upRow,upCol) <= map(row,col)
        % Add bin as part of the field
        rows = [rows; upRow];
        cols = [cols; upCol];
        visited(upRow, upCol) = 0;
    end
end
% Check down
if downCol <= size(map,1) % Inside map
    if visited(downRow,downCol) && map(downRow,downCol) <= map(row,col)
        % Add bin as part of the field

        rows = [rows; downRow];
        cols = [cols; downCol];
        visited(downRow, downCol) = 0;
    end
end