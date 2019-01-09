

%[foo, a]  = max(delta_trial_averaged_array)
close all
clear mean_trial_lengths;
clear max_loc
for i_struct = 1:length(filtered_ratemap_list)
    cur_ratemap_struct = filtered_ratemap_list{i_struct};
    mean_trial_lengths(i_struct) = mean(cur_ratemap_struct.trial_lengths(find(cur_ratemap_struct.manipulation_trial)));
    for manip_label = 1:3
        
        
        slice = delta_trial_averaged_array(i_struct, :, manip_label);
        %slice = delta_trial_averaged_array(i_struct, :, manip_label);
        %       [a, b] = max(slice');
        slice_weight = exp(slice* 2);
        
        delta_x_list = 2 * ((-delta_iX_lim):delta_iX_lim);
        slice_weight_times_x = slice_weight .*delta_x_list;
        max_loc(i_struct, manip_label) = sum(slice_weight_times_x)/sum(slice_weight);
        
    end
end

if(1)
    pre_during_post_array = max_loc;
    PrePostDuringCompare
    [a, b] = CorrPValue(v1-v2, mean_trial_lengths', 'Spearman')
    
end

if(0)
    m1 = 1;
    m2 = 3;
    
    
    ScatterWithSpine(max_loc(:, m1), max_loc(:, m2));
    
    sign_flip_p_val =  signFlipPValue(sign(max_loc(:, m1)- max_loc(:, m2)));
    title(sprintf('Sign Flip P value is %f \n',sign_flip_p_val))

else
    
end
    for manip_label = 1:3
        fprintf('Sign Flip P for inter-condition shift %d is %f \n', manip_label, signFlipPValue(sign(max_loc(:, manip_label))))
    end