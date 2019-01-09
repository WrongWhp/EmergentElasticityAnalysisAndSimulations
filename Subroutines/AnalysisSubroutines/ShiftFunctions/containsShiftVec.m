function [contains_vec] = containsShiftVec(shift_list, shift_struct)

contains_vec = 0;

for i = 1:length(shift_list)
    cur_struct = shift_list{i};
    contains_vec = or(contains_vec, and(cur_struct.iX == shift_struct.iX, cur_struct.iY == shift_struct.iY));
end