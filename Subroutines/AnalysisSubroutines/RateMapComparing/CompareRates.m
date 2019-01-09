function [difference, overlap] = CompareRates(vec1, vec2)


overlap = sum(isfinite(vec1(:) .* vec2(:)));

difference = NanCosineTheta(vec1, vec2);

%difference  = PercentOff(vec1, vec2);