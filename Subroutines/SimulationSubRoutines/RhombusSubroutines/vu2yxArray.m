function [yx] = vu2yx(vu)
%Basis switch. I use this enough to make it a subroutine. 

%x = u;
%y = v;

v = vu(1);
u = vu(2);

x = u + v * .5;
y = v * sqrt(3)/2.;

yx = [y x];
