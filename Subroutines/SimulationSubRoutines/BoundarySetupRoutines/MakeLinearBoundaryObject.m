function [output] = MakeLinearBoundaryObject(objective, sample_point);


output.type = 'LinearBoundary';
output.objective = objective;
output.sample_point = sample_point;


