function [output_array] = PrettifiedPhaseFromZ(phase_array)

output_array = zeros(size(phase_array));

for i = 2:length(phase_array)
    output_array(i) = output_array(i-1) + imag(log(phase_array(i)/phase_array(i-1)));    
end

