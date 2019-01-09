function [orthogonalized_indices] = orthogonalizePathConditionIndices(inds_1, inds_2, N)

%Loosely speaking, we want to say Condition 1 has an effect even when
%controlling for condition 2.


%inds_1 = 3:10;
%inds_2 =  4:11;
%N = 20;



cond1_met = zeros(N, 1);
cond1_met(inds_1) = 1;

cond2_met = zeros(N, 1);
cond2_met(inds_2) = 1;

cond1_met_cond2_met = and(cond1_met, cond2_met);
cond1_met_cond2_not_met = and(cond1_met, ~cond2_met);




p_cond1_given_cond2 = sum(cond1_met_cond2_met)./sum(cond2_met);
p_cond_1_given_notcond2 = sum(cond1_met_cond2_not_met)./sum(~cond2_met);

p_norm = min(p_cond1_given_cond2, p_cond_1_given_notcond2);

p_cond_1_given_notcond2;
p_cond1_given_cond2;


down_sampling_array = zeros(N, 1);
down_sampling_array(cond1_met_cond2_met) = p_norm/p_cond1_given_cond2;
down_sampling_array(cond1_met_cond2_not_met) = p_norm/p_cond_1_given_notcond2;
orthogonalized_indices = find(rand(size(down_sampling_array)) < down_sampling_array);



if(0)
    fprintf('************ \n');
    fprintf('Total cond1 array is %f \n', sum(cond1_met));
    fprintf('Total downsampling array is %f \n ', sum(down_sampling_array));
    
    fprintf('Total Orthagonalized Indices is %f, Corr With Cond2 is %f \n', length(orthogonalized_indices), indexCorrelation(orthogonalized_indices, inds_2, N));
    fprintf('************ \n');
    
end


