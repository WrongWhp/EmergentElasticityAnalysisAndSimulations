function [output] = MyHDR(input)
output = input;
output = output-min(output(:));
output = output/max(output(:));
output = .5 * (1+ tanh((output - .5) * 2));
output = output-min(output(:));
output = output/max(output(:));


