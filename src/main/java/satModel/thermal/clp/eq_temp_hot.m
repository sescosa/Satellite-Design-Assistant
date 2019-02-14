function res = eq_temp_hot(alphaIR,T, alphaVNIR, e, ep, Tp, Rp, h, AU_sun,qint,totalArea,ei,alphaTIRi,alphaVNIRi)
A1 = 0.5;
A2 = totalArea;
fun = @(Aradiator)calcDQ(T,Aradiator,alphaIR,alphaVNIR,e, ep,...
    Tp, Rp, h, AU_sun, qint,totalArea,ei,alphaTIRi,alphaVNIRi);

options = optimset('Display','iter');
res = fminbnd(fun,A1,A2,options);
return