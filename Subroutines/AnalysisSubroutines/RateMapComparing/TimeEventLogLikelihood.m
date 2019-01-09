function [log_likelihood] = TimeEventLogLikelihood(t1, t2, y1, y2)


local_lambda = (y1 + y2) ./ (t1 + t2);
local_lambda( (t1 + t2) == 0) = 0; %Get rid of nans


global_lambda_1 = sum(y1(:))/sum(t1(:));
global_lambda_2 = sum(y2(:))/sum(t2(:));

%global_lambda = sum(y1(:) + y2(:)) / sum(t1(:) + t2(:));



%Observed, expected
expected_1 = t1.* local_lambda;
expected_2 = t2 .* local_lambda;
local_log_likelihood = LogPoissPdf(y1, t1.*local_lambda) + LogPoissPdf(y2, t2.*local_lambda);

null_log_likelihood =  LogPoissPdf(y1, y1) + LogPoissPdf(y2, y2);
%null_log_likelihood = LogPoissPdf(y1, t1 * global_lambda_1) + LogPoissPdf(y2, t2 * global_lambda_2);



%The log likelihood when you assume they have their own distribution minus
%the log likelihood when they have to have their own distributions. 




log_likelihood_minus_null = local_log_likelihood - null_log_likelihood;


%log_likelihood_minus_null  = local_log_likelihood +50 * (t2 > 0); %Trying to fish out an effect. Better coverage will give a higher number. 
log_likelihood = sum(log_likelihood_minus_null(:)); %Might want to normalize at some point, not sure









