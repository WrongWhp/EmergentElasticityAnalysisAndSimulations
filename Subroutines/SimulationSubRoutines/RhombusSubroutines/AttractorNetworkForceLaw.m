function [force_mag] = AttractorNetworkForceLaw(dist)

%Calculates the force law. Different sets of attractor dynamics give
%slightly different force laws, so that can all be changed here. 
if(1)
    dist_cutoff = .5;
    force_mag = -(dist<dist_cutoff) .* sin(pi * (dist/dist_cutoff)) * (dist_cutoff/pi);
  %  (dist).*(dist_cutoff-dist)/(.25 * dist_cutoff^2);
    %Sinusoidal-like force law
else
    %Truncated Linear force law
    dist_cutoff = .5;
    force_mag = -(dist<dist_cutoff).*dist;
    
end


