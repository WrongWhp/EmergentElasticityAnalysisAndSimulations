function [output_array] = PrettifiedPhaseArray(phase_array, within_bounds)

phase_array = phase_array(within_bounds);
phase_array = phase_array/phase_array(1);


output_array(1) = 0;

for i = 2:length(phase_array)
    output_array(i) = output_array(i-1) + imag(log(phase_array(i)/phase_array(i-1)));    
end

