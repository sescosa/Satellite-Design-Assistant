m0 = 50;
dVi = 20;
dVa = 40;
Ispi = 210;
Ispa = 290;
pow = 100; %payload power
g = -9.81;

err = 1000;

mw = m0;
i = 1;
masses = [];
it = [];

while err > 0.1
    mp = mw*(1-exp(dVi/(g*Ispi))) + mw*(1-exp(dVa/(g*Ispa)));
    mw1 = 38*(0.14*pow + mp)^0.51;
    err = abs(mw-mw1);
    mw = mw1;
    i = i+1;
    masses = [masses mw1];
    it = [it i];
end

plot(it,masses);
    