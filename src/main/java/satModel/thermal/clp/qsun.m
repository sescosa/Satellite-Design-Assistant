function q = qsun(AU_sun,alphaVNIR,A,phi_s)
%Computes the total absorbed radiant energy from the Sun on a surface A 
%with absorptivity alpha in the VNIR at a distance AU_sun [AU] from the sun
%phi_s = 1368; % W/m^2
phi = phi_s/(AU_sun^2);
q = phi*alphaVNIR*A;
return