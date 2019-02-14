function q = qtherm(alphaIR, A, ep, Tp, Rp, h)
% Computes the total absorbed radiant energy from thermal emission of 
% a planet of radius Rp at temperature Tp with emissivity in the TIR ep, 
% by a surface A with absorptivity alp in the TIR at an altitude h
sig = 5.67051e-8; %stefan-boltzmann constant
q = alphaIR*vf_sphere_point(Rp,h)*ep*sig*Tp^4*A;
%q = alphaIR*phi_e*A;
return