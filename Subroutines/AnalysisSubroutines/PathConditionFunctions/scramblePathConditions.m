function [scrambled_cond_met_indices] = scramblePathConditions(orig_cond_indices, N)

%Divides it into sections where the condition was met and where the
%condition was not met, and scrambles them.  I could scramble them a little
%more thoroughly, sometimes two things get grouped together due to the edge
%condition where there may be one more or less streak where the condition
%was met than where it wasnt met.

%orig_cond_indices = find(sin((.5:.15:10).^2) > 0);
%N = 70
%orig_cond_indices = 4:8
%N = 20;


cond_met_array  = zeros(N, 1);
cond_met_array(orig_cond_indices) = 1;

cond_met_islands_struct = bwconncomp(cond_met_array);
cond_not_met_islands_struct = bwconncomp(~cond_met_array);


cond_met_ind_list = cond_met_islands_struct.PixelIdxList;
cond_not_met_ind_list = cond_not_met_islands_struct.PixelIdxList;


%Pads one list such that they are the same length
cond_met_list_length = length(cond_met_ind_list);
cond_not_met_list_length = length(cond_not_met_ind_list);
if(cond_met_list_length > cond_not_met_list_length)
   cond_not_met_ind_list{cond_not_met_list_length + 1} = [];
end
if(cond_met_list_length < cond_not_met_list_length)
   cond_met_ind_list{cond_met_list_length + 1} = [];
end



ind_list_length = length(cond_met_ind_list);
cond_met_perms = randperm(ind_list_length);
cond_not_met_perms = randperm(ind_list_length);



for i = 1:ind_list_length
        cond_met_ind_list{i} = cond_met_ind_list{i} - min(cond_met_ind_list{i});
        cond_not_met_ind_list{i} = cond_not_met_ind_list{i} - min(cond_not_met_ind_list{i});
end



scrambled_cond_met_list = zeros(N, 1);
%Actually fills the array
cur_starting_point = 1;
for i =1:ind_list_length
    shifted_cond_met_inds = cond_met_ind_list{cond_met_perms(i)} + cur_starting_point;
    scrambled_cond_met_list(shifted_cond_met_inds) = 2;
    cur_starting_point = max(cur_starting_point, max([shifted_cond_met_inds; -inf]+1));
    
%    scrambled_cond_met_list'
%    pause;
    
    shifted_cond_not_met_inds = cond_not_met_ind_list{cond_not_met_perms(i)} + cur_starting_point;
    scrambled_cond_met_list(shifted_cond_not_met_inds) = 1;
    cur_starting_point = max(cur_starting_point, max([shifted_cond_not_met_inds; -inf]+1));
    
%    scrambled_cond_met_list'
%    pause;
    
end

if(randn()<0)
    scrambled_cond_met_list = fliplr(flipud(scrambled_cond_met_list));    
end
scrambled_cond_met_indices = find(scrambled_cond_met_list == 2);

