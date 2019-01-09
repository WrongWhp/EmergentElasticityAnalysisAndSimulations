function [cos] = NanCosineTheta(vec1, vec2)

vec1_unraveled = vec1(:);
vec2_unraveled = vec2(:);

both_not_nan = ~(isnan(vec1_unraveled .* vec2_unraveled));


vec_1_cropped  = vec1_unraveled(both_not_nan);
vec_2_cropped = vec2_unraveled(both_not_nan);



vec_length  = min(length(vec_1_cropped), 40);

%Crop it down to reduce correlation between coverage and the result. 
for i = 1:30
    rand_perm = randperm(length(vec_1_cropped));

    further_crop_inds=  rand_perm(1:vec_length);
    
    v1_more_cropped = vec_1_cropped(further_crop_inds);
    v2_more_cropped = vec_2_cropped(further_crop_inds);
    
    vec_1_cropped_meansubtract = v1_more_cropped - mean(v1_more_cropped);
    vec_2_cropped_meansubtract = v2_more_cropped - mean(v2_more_cropped);
    
    
    cos_list(i) = dot(vec_1_cropped_meansubtract, vec_2_cropped_meansubtract)/(norm(vec_1_cropped_meansubtract) * norm(vec_2_cropped_meansubtract));
end

cos = mean(cos_list);
%cos = sum(vec1(:).*vec2(:))/(norm(vec1) * norm(vec2));