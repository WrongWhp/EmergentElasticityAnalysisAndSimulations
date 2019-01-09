
for path_cond_type_ind = path_cond_type_ind_list
    close all
    
    a1 = v1_v2_diff{path_cond_type_ind}{1}{1};
    a2 = v1_v2_diff{path_cond_type_ind}{3}{2};
    
    [a1_a2_corr, a1_a2_corr_p_values] = CorrPValue(a1, a2, 'spearman');
    scatter(a1, a2);
    title(sprintf('%s (x) vs. \n %s (y) \n Corr is %f With PValue of %f', path_condition_array{path_cond_type_ind}{1}.name, path_condition_array{path_cond_type_ind}{3}.name , a1_a2_corr, a1_a2_corr_p_values));
    output_path = sprintf('%s/OutputScatter/ShiftShiftcorrelation/%s.png', ap.output_path, path_condition_array{path_cond_type_ind}{1}.name)
    MakeFilePath(output_path);
    saveas(1, output_path);
    saveas(1, strrep(output_path, '.png', '.fig'));
    
end


