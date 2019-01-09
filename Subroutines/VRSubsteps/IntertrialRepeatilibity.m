
function [mean_repeat] =  IntertrialRepeatilibity(mean_firing_rate_sub_array)



trial_numbers = 1:size(mean_firing_rate_sub_array,1);
for trial_num = trial_numbers
    for trial_num_2 = trial_numbers
        cur_trial = mean_firing_rate_sub_array(trial_num, :);
        other_trial = mean_firing_rate_sub_array(trial_num_2, :);
        cos_theta_array(trial_num, trial_num_2) = NanCosineTheta(cur_trial-mean(cur_trial), other_trial - mean(other_trial));        
    end    
end

n_trials = length(trial_numbers);

[iX, iY] = meshgrid(trial_numbers);
%my_mask = (ones(n_trials, n_trials) - eye(n_trials) )> 0;
my_mask = IsBetween(abs(iX - iY), .5, 1.5);
my_mask_2 =IsBetween( abs(iX - iY), 6, 10);
mean_repeat = mean(cos_theta_array(my_mask));

%mean_repeat = mean(cos_theta_array(my_mask)) - mean(cos_theta_array(my_mask_2));