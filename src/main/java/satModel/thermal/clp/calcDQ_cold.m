function dq = calcDQ_cold(T,Aradiator,alphaIR,e, ep, Tp, Rp, h, qint,alphaVNIR,AU_sun,totalArea,ei,alphaTIRi,alphaVNIRi)
Ainsulator = 0.9*totalArea - Aradiator;
alb = 0.23; %earth albedo cold case
phi_s = 1326; %cold case
%phi_e = 208; % earth radiation cold case

% qin_radiator =  qsun(AU_sun,alphaVNIR,Aradiator,phi_s) + qalb(AU_sun,alb,alphaVNIR,Aradiator,phi_s) + ...
%     + qtherm(alphaIR,Aradiator,phi_e ) + qint;

% Cold case, radiator pointing to out space (nothing in front)

qin_radiator = qint;

qin_insulator = qsun(AU_sun,alphaVNIRi,0.2*Ainsulator,phi_s) + qalb(AU_sun,alb,alphaVNIRi,0.5*Ainsulator,phi_s) + ...
    + qtherm(alphaTIRi, 0.5*Ainsulator,ep, Tp, Rp, h);

qout = qrad(e, T, Aradiator) + qrad(ei,T,Ainsulator);

dq = abs(qout - qin_radiator - qin_insulator);
return