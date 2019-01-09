assert(strcmp(sysparams.run_type, 'LinearTrack'), 'Wrong Sysparams RunType in Generate1DSingleRunPath');

fprintf('Generating path... ');
GenerateCornerStartLocation;


path.title = 'Single Run Path';
path.dt = sysparams.spacing/sysparams.mouse_vel;



%path.run_steps = sysparams.steps_per_pixel * sum(system.in_bounds(:));


path.iX = system.mesh.iX(system.in_bounds);
path.iY = system.mesh.iY(system.in_bounds);

path.iX = [path.iX(1); path.iX]; %Pad the start
path.iY = [path.iY(1); path.iY];

%Pad the values with a 0 for indexing reasons. Now delta(i) = X(i) - X(i-1)
path.delta_iX = [0; diff(path.iX)];
path.delta_iY = [0; diff(path.iY)];
path.run_steps = length(path.iX);
fprintf('Finished! \n');


