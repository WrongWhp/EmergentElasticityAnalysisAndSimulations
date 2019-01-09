function [fr] = SamMakeFiringRateList(post, cellTS)



%Terribly inefficient, but it's ok for now.
fr = zeros(size(post));
mean_time_diff = mean(diff(post));
fr_length = length(fr);

for i = 1:length(cellTS)
     
   delta_t = cellTS(i) - post;
   delta_t(delta_t<0) = inf;
   [time_offset, min_ind] = min(delta_t);
   
   
   shift_coeff = time_offset/mean_time_diff;
   
    
%   [~, min_ind] = min(abs(post - cellTS(i)));
   
   fr(min_ind)   = fr(min_ind)   + (1- shift_coeff);    
   ind2 = min(min_ind + 1, fr_length);
   fr(ind2) = fr(ind2) + shift_coeff;       
end

%my_filter = fspecial('gaussian', [15 1], 2);

%fr = imfilter(fr, my_filter);


