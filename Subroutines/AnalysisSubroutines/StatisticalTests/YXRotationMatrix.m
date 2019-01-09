function [matrix] = YXRotationMatrix(theta)


matrix = [cos(theta) sin(theta); -sin(theta) cos(theta)];