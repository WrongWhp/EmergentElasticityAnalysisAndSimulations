function [output] = InteriorRectangle(input, rect_size)
center = round((1 + size(input))/2);

iY = (-rect_size(1)):rect_size(1);
iX = (-rect_size(2)):rect_size(2);

output = input(iY+ center(1), iX+ center(2));


