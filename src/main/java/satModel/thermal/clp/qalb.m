function q = qalb(AU_sun,alb,alphaVNIR,A,phi_s)
% Computes the total absorbed  solar radiance reflected off a surface with 
% albedo alb onto a surface A with absorptivity alpha in the VNIR
q = alb*qsun(AU_sun,alphaVNIR,A,phi_s);
return