function [y, x] = vu2yx(v, u)
%Basis switch. I use this enough to make it a subroutine. 

%x = u;
%y = v;

x = u + v * .5;
y = v * sqrt(3)/2.;


