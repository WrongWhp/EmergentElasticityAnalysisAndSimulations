function [inter_ind_corr_coeff] = InterIndCorrCoeff(values, id_inds)


%If we tried to predict each value using the values of entries with
%identical identifiers, how well would we do?
%values = [1 2 11 22];
%id_inds = [1 1 2 2];

mean_sub_values = values - mean(values);
norm_values = mean_sub_values/sqrt(mean(mean_sub_values.^2));

for i = 1:length(norm_values)
%   fprintf('Here!\n');
    same_id_inds = id_inds(i) == id_inds;
    same_id_inds(i) = 0;
    
    predicted_val(i) = nanmean(values(same_id_inds));
    
end

inter_ind_corr_coeff = NanCosineTheta(predicted_val, values);

% 
% for i = 1:length(norm_values)
%     fprintf('Here!\n');
%     same_inds = id_inds(i) == id_inds;
%     all_inds = logical(ones(size(same_inds)));
%     
%     
%     same_inds(i) = 0;
%     all_inds(i) = 0;
%     
%     cur_norm_value = norm_values(i);
%     
%     base_coeff(i) = nanmean(cur_norm_value .* norm_values(all_inds));
%     same_ind_coeff(i) = nanmean(cur_norm_value .* norm_values(same_inds));
%     
%     cur_norm_value
%     same_norm_vals = norm_values(same_inds)
% end
% 
% norm_values
% 
% inter_ind_corr_coeff = nanmean(same_ind_coeff- base_coeff)