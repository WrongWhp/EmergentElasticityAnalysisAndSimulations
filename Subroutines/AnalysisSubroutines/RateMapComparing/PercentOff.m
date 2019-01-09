function [perc_off] = PercentOff(vec1, vec2)




vec1_unraveled = vec1(:);
vec2_unraveled = vec2(:);

vec1_unraveled = vec1_unraveled/nanmean(vec1_unraveled);
vec2_unraveled = vec2_unraveled/nanmean(vec2_unraveled);


both_not_nan = ~(isnan(vec1_unraveled .* vec2_unraveled));


vec_1_cropped  = vec1_unraveled(both_not_nan);
vec_2_cropped = vec2_unraveled(both_not_nan);

perc_off_list = abs(vec_1_cropped - vec_2_cropped)./max(vec_1_cropped, vec_2_cropped);
perc_off_list(isnan(perc_off_list)) = 0;

perc_off = mean(perc_off_list);




