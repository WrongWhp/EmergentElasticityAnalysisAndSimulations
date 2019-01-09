function [inter_ind_corr_coeff inter_ind_p_val] = InterIndCorrTest(values, id_inds)



inter_ind_corr_coeff = InterIndCorrCoeff(values, id_inds);



for i  = 1:1000
    perm_id_inds = id_inds(randperm(length(id_inds)));
    
   rand_coeffs(i) =  InterIndCorrCoeff(values, perm_id_inds);
    
end


inter_ind_p_val = mean(inter_ind_corr_coeff<rand_coeffs) + .5 * mean(inter_ind_corr_coeff == rand_coeffs);