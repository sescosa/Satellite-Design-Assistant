function f = solar_panel_mode(k,m,a,b,d)
J0 = m*(a^2 + b^2)/12;
J = J0 + m*d^2;
omega = (k/J)^0.5;
f = omega/(2*pi);
return