fprintf('Generating path... ');
%GenerateCentralStartLocation;
GenerateCornerStartLocation;


path.title = 'Random Walk Path';
path.dt = sysparams.spacing^2.; %This is to ensure a constant diffusitivy that doesn't depend on the lattice size
path.run_steps = sysparams.steps_per_pixel * sum(system.in_bounds(:));

path.iX = zeros(path.run_steps, 1);
path.iY = zeros(path.run_steps, 1);

cur_iX = path.start_location(2);
cur_iY = path.start_location(1);


%For every time step,
%1) Decide whether to move in x or y direction. 
%2) Decide *which* way to move
%3) If it's not a wall, move there 

for iT = 1:path.run_steps
    path.iX(iT) = cur_iX;
    path.iY(iT) = cur_iY;
    
    if(PMOne()>0)
        proposed_iX = cur_iX + PMOne();
        proposed_iY = cur_iY;
    else
        proposed_iX = cur_iX;
        proposed_iY = cur_iY + PMOne();        
    end
    
    if(system.in_bounds(proposed_iY, proposed_iX))
        cur_iX = proposed_iX;
        cur_iY = proposed_iY;
    end
end


%Calculate the delta array as a helper. 
%We pad the values with a 0 for indexing reasons, such that delta(iT) = X(iT) - X(iT-1)
path.delta_iX = [0; diff(path.iX)];
path.delta_iY = [0; diff(path.iY)];
fprintf('Finished! \n');

