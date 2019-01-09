function [return_value] = indexCorrelation(ind1, ind2, array_length)

array_1 = zeros(array_length, 1);
array_2 = zeros(array_length, 1);


array_1(ind1) = 1;
array_2(ind2) = 2;

corr_matrix = corrcoef(array_1, array_2);
return_value = corr_matrix(2,1);


