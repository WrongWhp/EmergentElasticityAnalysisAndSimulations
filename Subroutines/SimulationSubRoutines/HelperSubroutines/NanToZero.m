function[output] = NanToZero(input)

output = input;
output(isnan(output)) = 0;