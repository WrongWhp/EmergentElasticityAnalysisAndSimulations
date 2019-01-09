function [spkx,spky,spkInd] = SamSpikePos(ts,posx,posy,post)
N = length(ts);
spkx = zeros(N,1);
spky = zeros(N,1);
spkInd = zeros(N,1);

count = 0;
for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    [~,ind] = min(tdiff);
    
    spkx_ii(ii) = posx(ind(1));
    spky_ii(ii) = posy(ind(1));
    spkInd_ii(ii) = ind(1);

end

not_nan = isfinite(spkx_ii + spky_ii);

spkx = spkx_ii(not_nan);
spky = spky_ii(not_nan);
spkInd = spkInd_ii(not_nan);

return