function f = bend_mode(E,I,m,L)
k = 3*E*I/(L^3);
omega = (k/m)^0.5;
f = omega/(2*pi);
return