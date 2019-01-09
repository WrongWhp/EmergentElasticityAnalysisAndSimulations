function [pvalue] = BinomialPValue(total_samples, n_heads)


n_monte_carlo = 1000000.;
times_satisfied = 0;

for i = 1:n_monte_carlo
    my_array = randi(2, total_samples, 1) - 1;
    
    times_satisfied = times_satisfied + (sum(my_array) > n_heads) + .5*(sum(my_array) == n_heads);
    
end


pvalue = times_satisfied/n_monte_carlo;