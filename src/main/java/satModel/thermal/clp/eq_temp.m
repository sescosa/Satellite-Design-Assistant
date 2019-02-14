function res = eq_temp_cold(alphaIR,T, alphaVNIR, e, ep, Tp, Rp, h, AU_sun,qint)
A1 = 1;
A2 = 10;
fun = @(Acold)calcDQ(T,Acold,Acold,Acold,alphaIR,alphaVNIR,e, ep, Tp, Rp, h, AU_sun, qint);
options = optimset('Display','iter');
res = fminbnd(fun,A1,A2,options);
return