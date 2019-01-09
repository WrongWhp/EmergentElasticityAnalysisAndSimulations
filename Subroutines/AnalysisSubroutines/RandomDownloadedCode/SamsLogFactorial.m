function [log_factorial] = SamsLogFactorial(n);

log_factorial = Stirling(n, 1) * log(10);