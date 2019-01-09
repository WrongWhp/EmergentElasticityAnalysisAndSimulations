function [cos] = NonNormCosTheta(vec1, vec2)

vec1_unraveled = vec1(:);
vec2_unraveled = vec2(:);


cos = dot(vec1_unraveled, vec2_unraveled)/(norm(vec1_unraveled) * norm(vec2_unraveled));

%cos = sum(vec1(:).*vec2(:))/(norm(vec1) * norm(vec2));