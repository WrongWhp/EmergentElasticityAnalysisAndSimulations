function [vu] = yx2vu(yx);
%Basis switch. I use this enough to make it a subroutine. 


%u = x;
%v = y;
y = yx(1);
x = yx(2);

u = x - y/sqrt(3); %Hopefully will produce hexagonal lattice
v = y * 2./sqrt(3);

vu = [v u];