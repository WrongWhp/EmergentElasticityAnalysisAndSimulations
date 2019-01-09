function [output] = MakeHorizontal(input)

input_size = size(input);

if(input_size(1) == 1)
    
    
    output = input;
    
else
    output = input';
    
end