function [base_corr, pvalue] = CorrPValue(x_in, y_in, corr_type)


%Types are 'Spearman', 'Pearson'
not_nans = isfinite(x_in + y_in);
if(sum(not_nans)==0)
    base_corr = nan;
    pvalue = nan;
else
    
    x = x_in(not_nans);
    y = y_in(not_nans);
    
    n_monte_carlo = 1000.;
    
    base_corr = corr(MakeHorizontal(x)',  MakeHorizontal(y)', 'type', corr_type);
    
    
    times_satisfied = 0;
    
    for i = 1:n_monte_carlo
        perm1 = randperm(length(x));
        perm2 = randperm(length(y));
        monte_carlo_corr =  corr(MakeHorizontal(x(perm1))',  MakeHorizontal(y(perm2))', 'type', corr_type);
        is_satisfied_array(i) = 1. *(monte_carlo_corr > base_corr) + .5 * (monte_carlo_corr == base_corr);
    end
    
    mean_at_least = mean(is_satisfied_array>0);
    
    pvalue = mean(is_satisfied_array);
    
end