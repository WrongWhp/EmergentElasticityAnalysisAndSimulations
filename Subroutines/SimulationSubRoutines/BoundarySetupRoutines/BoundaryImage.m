function [output] = BoundaryImage(mesh, boundary_obj);

%Takes a boundary object and constructs a mask of all points where that boundary is satisfied

if(strcmp(boundary_obj.type, 'LinearBoundary'))
   output = LinearBoundaryImage(mesh, boundary_obj); 
end

if(strcmp(boundary_obj.type, 'InteriorRectangleBoundary'))
   output = InteriorRectangleBoundaryImage(mesh, boundary_obj); 
end