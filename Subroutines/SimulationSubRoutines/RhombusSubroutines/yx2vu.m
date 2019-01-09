function [v, u] = yx2vu(y, x);
%Basis switch. I use this enough to make it a subroutine. 


%u = x;
%v = y;


u = x - y/sqrt(3); %Hopefully will produce hexagonal lattice
v = y * 2./sqrt(3);
