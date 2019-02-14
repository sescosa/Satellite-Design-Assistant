function Q = calcRadiant(T,A,e)
% Computes the total radiant energy in W radiated by a surface A at
% temperature T
sig= 5.67051e-8; %stefan-boltzmann constant
Q = sig*e*T^4*A;
return