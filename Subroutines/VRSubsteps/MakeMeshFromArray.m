function [output_mesh] = MakeMeshFromArray(array);

x = 1:size(array,2);
y = 1:size(array, 1);
x = x - mean(x);
y = y - mean(y);

[output_mesh.x, output_mesh.y] = meshgrid(x, y);