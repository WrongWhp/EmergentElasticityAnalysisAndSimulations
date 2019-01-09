function [total_V_force, total_U_force] = ForceArrayFromRhDist(rh_dist)


norm_rh_dist = rh_dist/sum(rh_dist(:)); %Normalized so that the sum is 1
rh_graining = size(rh_dist, 1);

total_U_force = zeros(size(rh_dist));
total_V_force = zeros(size(rh_dist));


[one_one_centered_V_Force, one_one_centered_U_Force] = CenteredRhForceArray(rh_graining); %Force law centered about (1,1)

zero_zero_centered_V_Force =  circshift(one_one_centered_V_Force, [-1 -1]);%The resultant forces from a distribution at (0,0), which is also the upper right corner.
zero_zero_centered_U_Force =  circshift(one_one_centered_U_Force, [-1 -1]);



%Convolute the force law by the learned distribution of each landmark. 
%This could probably be done by imfilter
for iV = 1:rh_graining
   for iU = 1:rh_graining
       
       cur_weight = norm_rh_dist(iV, iU);
       total_U_force = total_U_force + circshift(zero_zero_centered_U_Force, [iV iU])  * cur_weight;
       total_V_force = total_V_force + circshift(zero_zero_centered_V_Force, [iV iU])  * cur_weight;       
   end
end


