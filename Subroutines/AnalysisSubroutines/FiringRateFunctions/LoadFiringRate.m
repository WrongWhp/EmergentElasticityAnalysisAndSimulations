function [cellTS] = LoadFiringRate(firing_rate_path)


%Just a way to accomodate different naming convenctions.
load(firing_rate_path);

if(exist('ts'))
    
    cellTS = ts;
    
end
