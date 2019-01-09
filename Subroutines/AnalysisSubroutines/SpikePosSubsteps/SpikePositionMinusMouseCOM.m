function [posit_minus_mouseCOM] = SpikePositionMinusMouseCOM(posx, posy, mouse_COM)

[cmx_mesh, posx_mesh] = meshgrid(mouse_COM.base_x, posx);
[cmy_mesh, posy_mesh] = meshgrid(mouse_COM.base_y, posy);

dist_squared = (cmx_mesh - posx_mesh).^2 + (cmy_mesh -posy_mesh).^2;

[min_dist  min_ind] = min(sqrt(dist_squared), [], 2);%Minimize over the center of masses



min_ind(min_dist > 10) = nan;%If Somethings too far away we get rid of it.
ok_field =and( abs(mouse_COM.base_x)<30, abs(mouse_COM.base_x)<30);

for j = 1:length(mouse_COM.base_x)
    posit_minus_mouseCOM.x{j} = [];
    posit_minus_mouseCOM.y{j} = [];
    
    if(ok_field(j))
        inside_field = min_ind == j;
        cond_com.count(j) = sum(inside_field);
%        fprintf('Total is %d \n', sum(inside_field));
        %    size(inside_field)
        %    size(cm_x)
        posit_minus_mouseCOM.x{j} =  posx(inside_field) - mouse_COM.x(j);
        posit_minus_mouseCOM.y{j} =  posy(inside_field) - mouse_COM.y(j);
    end
    
end
