function [condition_met] = LastHitWallPathCondition(path, vec)
%Conditions based on which wall the animal last touched. 


dot_product = vec(1) * path.iY + vec(2) * path.iX;
max_dot = max(dot_product);
min_dot = min(dot_product);
cond_cur_met = 0;
condition_met = path.iX * 0;
%size(dot_product)
%size(condition_met)
%max_dot
%min_dot
%cond_cur_met
%plot(dot_product==max_dot);
%pause;

for iT = 1:length(path.iX)
   cur_dot = dot_product(iT);
   cond_cur_met = or(cond_cur_met, cur_dot == max_dot);
   cond_cur_met = and(cond_cur_met, cur_dot ~= min_dot);
%   cond_cur_met = and(or(cond_cur_met, cur_dot == max_dot), cur_dot == min_dot);   
   
%   iT
   condition_met(iT) =  cond_cur_met;
end
