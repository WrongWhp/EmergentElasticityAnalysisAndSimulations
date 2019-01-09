function [pvalue] = signFlipPValue(v)

monte_carlo_steps = 1000000;

base_mean = nanmean(v);


for i = 1:monte_carlo_steps
    %If we randomize the signs, how likely are we to get an answer that's
    %similarly positive or negative. 
   mean_list(i) = nanmean(v .* sign(randn(size(v))));    
end

pvalue = 1. * mean(mean_list > base_mean) + .5 * mean(mean_list == base_mean);

