%% POWER SUBSYSTEM DESIGN
% Author: Sergio Escosa
%% Solar array
Pavg = Pavg_payload/0.4;
Ppeak = Ppeak_payload/0.4;
Pd = 0.8*Pavg + 0.2*Ppeak;
Pe = Pd;
Td = period*frac_sunlight;
Te = period - Td;
Psa = (Pe*Te/Xe + Pd*Td/Xd)/Td;

P_density_bol = abs(P0*Id*cos(worst_sun_angle));

x = [202,253,301];
y = [0.0275,0.0375,0.005];
p = polyfit(x,y,2);
degradation = p(1)*P0^2 + p(2)*P0 + p(3);

Ld = (1- degradation)^lifetime;
P_density_eol = abs(P0*Id*cos(worst_sun_angle))*Ld;

EQN1 = Asa == Psa/(abs(P0*Id*cos(worst_sun_angle))*Ld);

%% Batteries
Cr = Pe*Te/(3600*DOD*n); %period is in seconds
EQN2 = mass_batt == (Pe*Te/(3600*DOD*n))/spec_energy_density_batt;

%% Solvers 
% are added by the java code because can change
%mass_batt = double(vpa(solve(EQN2, mass_batt)));
%Asa = double(vpa(solve(EQN1,Asa)));
