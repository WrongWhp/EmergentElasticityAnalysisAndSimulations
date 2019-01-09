function [c_o_a] =  centerOfArrayMask(input)

    c_o_a = input* 0;
    c_o_a(round((1 + size(input, 1))/2), round((1 + size(input, 2))/2) )= 1;