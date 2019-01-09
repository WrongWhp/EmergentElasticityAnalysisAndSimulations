function [condition_met] = DirectionalPathCondition(path, vec, delta_T, min_length)

%Conditions based on how the animal's position compares to where it was a
%certain amount of time ago.

delta_iT =  round(delta_T/ path.dt);


cur_iT = 1:length(path.iX);
prev_iT = max(cur_iT - delta_iT, 1);

%cur_dot_product = vec(1) * path.iY + vec(2) * path.iX;


prev_iX = path.iX(prev_iT);
prev_iY = path.iY(prev_iT);

diff_iX = path.iX - prev_iX;
diff_iY = path.iY - prev_iY;


%prev_dot_product = vec(1)* prev_iY + vec(2) * prev_iX;

diff_dot_product = vec(1)* diff_iY + vec(2) * diff_iX;

condition_met = (diff_dot_product >= min_length);
condition_met = and(condition_met, prev_iT' > 1);
