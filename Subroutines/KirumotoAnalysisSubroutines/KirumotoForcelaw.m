function [force] = KirumotoForcelaw(theta, phi);

%mod_diff = mod(theta-phi + pi) -pi;

mod_diff = mod(theta-phi + pi, 2*pi) -pi;
force = sin(mod_diff);