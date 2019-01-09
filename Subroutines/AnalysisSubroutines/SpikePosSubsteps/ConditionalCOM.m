function [cond_com] = ConditionalCOM(cm_x, cm_y, posx, posy)

[cmx_mesh, posx_mesh] = meshgrid(cm_x, posx);
[cmy_mesh, posy_mesh] = meshgrid(cm_y, posy);

dist_squared = (cmx_mesh - posx_mesh).^2 + (cmy_mesh -posy_mesh).^2;

[min_dist  min_ind] = min(sqrt(dist_squared), [], 2);%Minimize over the center of masses



min_ind(min_dist > 10) = nan;%If Somethings too far away we get rid of it.

for j = 1:length(cm_x)
    inside_field = min_ind == j;
    cond_com.count(j) = sum(inside_field);
%    size(inside_field)
%    size(cm_x)
    cond_com.x(j) = mean(posx(inside_field));
    cond_com.y(j) = mean(posy(inside_field));
    
end

cond_com.base_x = cm_x;
cond_com.base_y = cm_y;

