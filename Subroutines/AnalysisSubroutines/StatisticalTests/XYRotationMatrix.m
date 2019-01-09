function [matrix] = XYRotationMatrix(theta)


matrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];