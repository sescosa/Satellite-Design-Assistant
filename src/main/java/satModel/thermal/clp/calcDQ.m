function dq = calcDQ(T,Aradiator,alphaIR,alphaVNIR,e, ep, Tp, Rp, h, AU_sun, qint,totalArea,ei,alphaTIRi,alphaVNIRi)
Ainsulator = 0.9*totalArea - Aradiator;
alb = 0.38; %earth albedo hot case
phi_s = 1418; %hot casçe
%phi_e = 233; %earth radiation hot case

% Hot case, radiator pointing out (pointing the sun, and 0 IR and albedo)
% qin_radiator =  qsun(AU_sun,alphaVNIR,Aradiator,phi_s) + qalb(AU_sun,alb,alphaVNIR,Aradiator,phi_s) + ...
%     + qtherm(alphaIR,Aradiator,phi_e ) + qint;

qin_radiator =  qsun(AU_sun,alphaVNIR,Aradiator,phi_s) + qint;

qin_insulator = qsun(AU_sun,alphaVNIRi,0.5*Ainsulator,phi_s) + qalb(AU_sun,alb,alphaVNIRi,0.5*Ainsulator,phi_s) + ...
    + qtherm(alphaTIRi,0.5*Ainsulator,ep, Tp, Rp, h);

qout = qrad(e, T, Aradiator) + qrad(ei, T, Ainsulator);

dq = abs(qout - qin_radiator - qin_insulator);
return