function [landmark_cell] = MakeCircularLandmarkCell(system, center, radius, strength, use_sharp_mask);


x_center = center(2);
y_center = center(1);

mesh = system.mesh;
dist_squared = (mesh.x - x_center).^2 + (mesh.y - y_center).^2;

if(use_sharp_mask)
    mask = double(dist_squared < radius^2);
else
    mask = exp(-dist_squared/radius^2);    
end


landmark_cell = MakeLandmarkCellFromMaskAndStrength(mask, system.rh_graining, strength);


landmark_cell.x_center = x_center;
landmark_cell.y_center = y_center;

landmark_cell.title = 'MakeCircularLandmarkCell';

end
