

%Generates a start location in the upper left corner. Simple and consistent
fprintf('Generating corner starting location ...   ');
iX_in_box = system.mesh.iX(logical(system.in_bounds));
iY_in_box = system.mesh.iY(logical(system.in_bounds));

[~, ind] = min(iX_in_box+ iY_in_box)

path.start_location = [iY_in_box(ind), iX_in_box(ind)];


fprintf('Finished ! \n');