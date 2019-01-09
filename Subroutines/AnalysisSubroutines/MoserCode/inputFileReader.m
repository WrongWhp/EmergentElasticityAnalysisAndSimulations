function [status, sessionArray, unitArray, roomArray, shapeArray] = inputFileReader(inputFile, roomFlag, shapeFlag,p)

% Status = 0 -> Input file contain errors
% Status = 1 -> Input file is ok
status = 0;

% Number of sessions possible to have listed in the input file
N = 1000;

% Mean number of cell per session
M = 100;

% Session name array
% 1: Session name (whole path)
sessionArray    = cell(N, 1);

% Room number
roomArray       = cell(N, 1);

% Box shape
shapeArray      = cell(N, 1);

% Tetrode and cell number.
% 1: Tetrode.
% 2: Cell number.
% 3: Session number. Tell which session the cell belongs to.
unitArray       = zeros(M*N, 3);

% Open the input file for binary read access
fid = fopen(inputFile,'r');

if fid == -1
    msgbox('Could''n open the input file! Make sure the filname and path are correct.','File read error','error');
    disp('Input file could not be found.')
    disp('Failed')
    return
end

% Counts the number of sessions
sessionCounter = 0;
% Count the number of cells
unitCounter = 0;

% Keep track of the line number the programs reads from in the input file
currentLine = 0;

while ~feof(fid)
    % Read a line from the input file
    str = fgetl(fid);
    currentLine = currentLine + 1;
    
    % Remove space at end of line
    str = stripSpaceAtEndOfString(str);
    
    % Check that line is not empty
    if isempty(str)
        disp('Error: There can''t be any empty lines in the input file');
        fprintf('%s%u\n','Empty line was found in line number ',currentLine);
        return
    end
    
    % Check that the line is the "session" line
    if length(str)<7
        disp('Error: Expected keyword ''Session'' in the input file');
        fprintf('%s%u\n','Error on line ', currentLine);
        return
    end
    if ~strcmpi(str(1:7),'Session')
        disp('Error: Expected keyword ''Session'' in the input file');
        fprintf('%s%u\n','Error on line ', currentLine);
        return
    else
        sessionCounter = sessionCounter + 1;
        sessionArray{sessionCounter,1} = str(9:end);
        


        if strcmpi(p.delim,'/')
            sessionArray{sessionCounter,1} = strrep(sessionArray{sessionCounter,1},'\','/');
        else
            sessionArray{sessionCounter,1} = strrep(sessionArray{sessionCounter,1},'/','\');
        end

        
        % Read next line
        str = fgetl(fid);
        currentLine = currentLine + 1;
        
        % Remove space at end of line
        str = stripSpaceAtEndOfString(str);
        
        % Check that line is not empty
        if isempty(str)
            disp('Error: There can''t be any empty lines in the input file');
            fprintf('%s%u\n','Empty line was found in line number ',currentLine);
            return
        end
    end
    
    if roomFlag
        % Room information should come next
        if length(str)<4 || ~strcmpi(str(1:4),'Room')
            fprintf('%s%u\n','Error: Expected the ''Room'' keyword at line ', currentLine)
            return
        else
            roomArray{sessionCounter} = str(6:end);
            str = fgetl(fid);
            currentLine = currentLine + 1;
            
            % Remove space at end of line
            str = stripSpaceAtEndOfString(str);

            % Check that line is not empty
            if isempty(str)
                disp('Error: There can''t be any empty lines in the input file');
                fprintf('%s%u\n','Empty line was found in line number ',currentLine);
                return
            end
        end
    end
    
    if shapeFlag == 1
        % Shape information should come next
        % 1 dim: shape. 1 = box, 2 = cylinder, 3 = linear track
        % 2 dim: Side length or diameter of the arena.
        shape = zeros(2,1);
        if length(str)<5 || ~strcmpi(str(1:5),'Shape')
            fprintf('%s%u\n','Error: Expected the ''Shape'' keyword at line ', currentLine)
            return
        else
            temp = str(7:end);
            if length(temp)>3 && strcmpi(temp(1:3),'Box')
                shape(1) = 1;
                shape(2) = str2double(temp(5:end));
                
            elseif length(temp)>5 && strcmpi(temp(1:5),'Track')
                shape(1) = 3;
                shape(2) = str2double(temp(7:end));
            elseif length(temp) > 6 && strcmpi(temp(1:6), 'Circle')
                shape(1) = 2;
                shape(2) = str2double(temp(8:end));
            elseif length(temp)>8 && strcmpi(temp(1:8),'Cylinder')
                shape(1) = 2;
                shape(2) = str2double(temp(10:end));
            else
                disp('Error: Missing shape information. Must be box, cylinder or Track');
                fprintf('%s%u\n','Error at line ', currentLine)
                return
            end

            
            % Add the shape information to the shape array
            shapeArray{sessionCounter} = shape;
            
            % Read next line
            str = fgetl(fid);
            currentLine = currentLine + 1;
            
            % Remove space at end of line
            str = stripSpaceAtEndOfString(str);

            % Check that line is not empty
            if isempty(str)
                disp('Error: There can''t be any empty lines in the input file');
                fprintf('%s%u\n','Empty line was found in line number ',currentLine);
                return
            end
        end
    end
    
    while ~feof(fid)
        if strcmp(str,'---') % End of this block of data, start over.
            break
        end
        
        if length(str)>7
            if strcmpi(str(1:7),'Tetrode')
                tetrode = sscanf(str,'%*s %u');
                
                % Read next line
                str = fgetl(fid);
                currentLine = currentLine + 1;
                
                % Remove space at end of line
                str = stripSpaceAtEndOfString(str);

                % Check that line is not empty
                if isempty(str)
                    disp('Error: There can''t be any empty lines in the input file');
                    fprintf('%s%u\n','Empty line was found in line number ',currentLine);
                    return
                end
                
                while length(str) > 4 && strcmpi(str(1:4),'Unit')
                    unit = sscanf(str,'%*s %u');
                    unitCounter = unitCounter + 1;
                    
                    % Add tetrode and cell number to the cell array
                    unitArray(unitCounter,1) = tetrode;
                    unitArray(unitCounter,2) = unit;
                    unitArray(unitCounter,3) = sessionCounter;
                    
                    str = fgetl(fid);
                    currentLine = currentLine + 1;
                    
                    % Remove space at end of line
                    str = stripSpaceAtEndOfString(str);
                    
                    % Check that line is not empty
                    if isempty(str)
                        disp('Error: There can''t be any empty lines in the input file');
                        fprintf('%s%u\n','Empty line was found in line number ',currentLine);
                        return
                    end
                end
            else
                fprintf('%s%u\n','Error: Expected the Tetrode keyword at line ', currentLine);
                return
            end
        else
            fprintf('%s%u\n','Error: Expected the Tetrode keyword at line ', currentLine);
            return
        end
        
    end
    
    
end

% Shorten the arrays
sessionArray = sessionArray(1:sessionCounter,:);
roomArray = roomArray(1:sessionCounter,:);
shapeArray = shapeArray(1:sessionCounter,:);
unitArray = unitArray(1:unitCounter,:);

% Set status to success (1)
status = 1;



% Removes space at the end of the string input
function str = stripSpaceAtEndOfString(str)

if isempty(str)
    return
end

while ~isempty(str)
    if strcmp(str(end),' ')
        str = str(1:end-1);
    else
        break;
    end
end