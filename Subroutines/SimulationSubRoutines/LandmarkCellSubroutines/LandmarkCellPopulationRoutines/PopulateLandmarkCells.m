
landmark_cell_list = {}


%MakeLandmarkCellsFromBoundaryImage
%MakeLandmarkCellsFromBoundaryList
%MakeCircularLandmarkCellsFromBoundaryList;
MakeUniBoundaryLandmarkCellsFromBoundaryList;

%MakeUniformCircularLandmarkCells;
    
%Adds an everywhere landmark cell with zero strength. This is just a way to
%take statistics
landmark_cell_list{length(landmark_cell_list)+1} = MakeEveryWhereLandmarkCell(system);


