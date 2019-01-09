function [log_likelihood] = LogPoissPdf(observed, expected)

log_likelihood = -expected +observed .* log(expected) - SamsLogFactorial(observed);



%If we expect 0 and get 0, the chance of that happening is 1.
log_likelihood(and(expected ==0, observed == 0)) = 0;


