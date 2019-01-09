function [iY, iX] = TwoDArrayMax(A)
[value, location] = max(A(:));
[iY,iX] = ind2sub(size(A),location);