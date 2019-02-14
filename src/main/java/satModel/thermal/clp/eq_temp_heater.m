function res = eq_temp_heater(Aradiator,alphaIR, alphaVNIR, e, ep, Tp, Rp, h, AU_sun,T,totalArea,ei,alphaTIRi,alphaVNIRi,Qmin)
T1 = 0.2;
T2 = 1000;
fun = @(qint)calcDQ_cold(T,Aradiator,alphaIR,e, ep, Tp, Rp, h, qint + Qmin,alphaVNIR,AU_sun,totalArea,ei,alphaTIRi,alphaVNIRi);
options = optimset('Display','iter');
res = fminbnd(fun,T1,T2,options);
return