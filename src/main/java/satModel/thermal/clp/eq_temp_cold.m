function res = eq_temp_cold(Aradiator,alphaIR, alphaVNIR, e, ep, Tp, Rp, h, AU_sun,qint,totalArea,ei,alphaTIRi,alphaVNIRi)
T1 = 1;
T2 = 500;
fun = @(T)calcDQ_cold(T,Aradiator,alphaIR,e, ep, Tp, Rp, h, qint,alphaVNIR,AU_sun,totalArea,ei,alphaTIRi,alphaVNIRi);
options = optimset('Display','iter');
res = fminbnd(fun,T1,T2,options);
return