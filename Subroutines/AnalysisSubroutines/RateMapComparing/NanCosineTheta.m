function [cos] = NanCosineTheta(vec1, vec2)

vec1_unraveled = vec1(:);
vec2_unraveled = vec2(:);

both_not_nan = ~(isnan(vec1_unraveled .* vec2_unraveled));


vec_1_cropped  = vec1_unraveled(both_not_nan);
vec_2_cropped = vec2_unraveled(both_not_nan);

vec_1_cropped_meansubtract = vec_1_cropped - mean(vec_1_cropped);
vec_2_cropped_meansubtract = vec_2_cropped - mean(vec_2_cropped);



cos = dot(vec_1_cropped_meansubtract, vec_2_cropped_meansubtract)/(norm(vec_1_cropped_meansubtract) * norm(vec_2_cropped_meansubtract));

%cos = sum(vec1(:).*vec2(:))/(norm(vec1) * norm(vec2));