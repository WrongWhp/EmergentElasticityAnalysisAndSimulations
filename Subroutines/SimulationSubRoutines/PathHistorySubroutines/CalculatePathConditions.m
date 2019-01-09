
fprintf('At Calculate path conditions \n');
%We calculate the path conditions. There are 8 path conditions, four about
%which direction it came from, and four about which wall it last touched.
%We calculate the entire trajectory and path conditions before calculating
%anything about the trajectory of the attractor network. 



path_condition_list  = {};
path_condition_list{1} =  1 +  ~DirectionalPathCondition(path, [1 0], 1, 1) *(sysparams.n_conds + 1 -1);  %Came from negative Y
path_condition_list{2} =  2 +  ~DirectionalPathCondition(path, [-1 0], 1, 1) *(sysparams.n_conds + 1 -2);  %Came from +Y
path_condition_list{3} =  3 +  ~DirectionalPathCondition(path, [0 1], 1, 1) *(sysparams.n_conds + 1 -3);
path_condition_list{4} =  4 +  ~DirectionalPathCondition(path, [0 -1], 1, 1) *(sysparams.n_conds + 1 -4);


path_condition_list{5} =  5 +  ~LastHitWallPathCondition(path, [1 0]) *(sysparams.n_conds + 1 -5);
path_condition_list{6} =  6 +  ~LastHitWallPathCondition(path, [-1 0]) *(sysparams.n_conds + 1 -6);
path_condition_list{7} =  7 +  ~LastHitWallPathCondition(path, [0 1]) *(sysparams.n_conds + 1 -7);
path_condition_list{8} =  8 +  ~LastHitWallPathCondition(path, [0 -1]) *(sysparams.n_conds + 1 -8); %

%function [condition_met] = DirectionalPathCondition(path, vec, delta_T, min_length)

