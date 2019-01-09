% Finds the position timestamp indexes for spike timestamps
function spkInd = getSpkInd(ts,post)
% Number of spikes
N = length(ts);
spkInd = zeros(N,1);



for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    [m,ind] = min(tdiff);
    
    spkInd(ii) = ind(1);
end