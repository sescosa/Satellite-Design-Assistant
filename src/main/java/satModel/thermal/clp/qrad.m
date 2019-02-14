function q = qrad(e,T,A)
% Calculates the total outgoing radiant energy from a surface A with 
% emissivity eps at temperature T
q = calcRadiant(T,A,e);
return