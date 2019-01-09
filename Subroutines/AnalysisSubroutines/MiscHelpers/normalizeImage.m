
%A Helper Method, which given an image, returns a noramlized version


function [normalizedImage]  = normalizeImage(image)

maxValue = max(image(:));
minValue = min(image(:));
normalizedImage = 1. *(image -minValue)/(maxValue-minValue);


