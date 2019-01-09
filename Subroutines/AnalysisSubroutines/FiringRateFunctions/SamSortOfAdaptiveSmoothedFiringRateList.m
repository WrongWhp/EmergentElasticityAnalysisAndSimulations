function [fr] = SamSortOfAdaptiveSmoothedFiringRateList(post, cellTS)


%post = 1:10;
%cellTS = [1.7 1.8 9.1];


%Terribly inefficient, but it's ok for now.
fr = zeros(size(post));
mean_time_diff = mean(diff(post));
fr_length = length(fr);

for i = 1:length(cellTS)
     
   delta_t = cellTS(i) - (post - 1/2);
   delta_t(delta_t<0) = inf;
   [time_offset(i), min_ind(i)] = min(delta_t);      
   shift_coeff(i) = time_offset(i)/mean_time_diff;   
    
%   [~, min_ind] = min(abs(post - cellTS(i)));
   
 %  fr(min_ind(i))   = fr(min_ind(i))   + (1- shift_coeff(i));    
 %  ind2 = min(min_ind(i) + 1, fr_length);
 %  fr(ind2) = fr(ind2) + shift_coeff(i);       
end

shift_coeff = min(shift_coeff, 1); %To trim off any big shift in the end



for i = 1:(length(cellTS) - 1)
   weight_matrix = zeros(size(fr));

   weight_matrix(min_ind(i)) = weight_matrix(min_ind(i)) +1 - shift_coeff(i); %Adds the left edge
   
   bulk_left_bound = min(min_ind(i) + 1, fr_length);      
   bulk_right_bound = min(min_ind(i+1)-1, fr_length);
   
   weight_matrix(bulk_left_bound:bulk_right_bound) = weight_matrix(bulk_left_bound:bulk_right_bound) + 1;

   weight_matrix(min_ind(i+1)) =    weight_matrix(min_ind(i+1))  + shift_coeff(i+1);
%   weight_matrix(bulk_left_bound:bulk_right_bound) = weight_matrix(bulk_left_bound:bulk_right_bound) + 1;


    fr = fr + weight_matrix/sum(weight_matrix);
   
      
end
%fr = imfilter(fr, my_filter);

%answer = [weight_matrix;post]

