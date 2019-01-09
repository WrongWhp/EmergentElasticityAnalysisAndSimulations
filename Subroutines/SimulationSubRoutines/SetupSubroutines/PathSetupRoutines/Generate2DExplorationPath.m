
%run_type = 'LinearTrack';
if(strcmp(sysparams.run_type, '2DExplore'))
    GenerateRandomWalkPath;    
else
   error('Wrong kind of runtype for Generate2dExplorationPath');
end
