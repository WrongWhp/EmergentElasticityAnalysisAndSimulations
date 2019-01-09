function[neg_entropy] = CalculateEntFromRandom(input)
%Calculates the entropy of a random distribution

unraveled_vec = input(:);
norm_vec = unraveled_vec/sum(unraveled_vec) + realmin;

neg_entropy =  sum(norm_vec .* log(norm_vec)) + log(prod(size(norm_vec)));
