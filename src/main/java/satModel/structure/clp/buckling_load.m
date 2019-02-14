function P = buckling_load(E,I,k,L)
Lp = k*L;
P = pi^2 * E*I/Lp^2;
return