%% Thermal Control System Design
% Author: Sergio Escosa

% % Insulator: MLI
% alphaVNIRi = 0.02;
% alphaTIRi =  0.02;
% ei = 0.02; % IR emissivity
% 
% % Radiator: Silvered Teflon
% alphaVNIR = 0.08;
% alphaTIR =  0.8;
% e = 0.82; % IR emisivity

ep = 0.5; % Earth emissivity
Rp = 6371000; %Earth radius
Tp = 287; %Earth average temperature
AU_sun = 1;

% h = 600000; %Altitude
% 
% % Electronics operational limits
% Tmin = -10;
% Tmax = 40;
% payload_power = 400; 
% Qmax = 150; % Hot case heat dispersion
% Qmin = 100; %Cold case heat dispersion
% 
% % Satellite dimensions
% dim1 = 2.2;
% dim2 = 1;
% dim3 = 1;

totalArea = 2*(dim1*dim2) + 2*(dim2*dim3) + 2*(dim1*dim3);
passive = false;

%% PASSIVE (heater = 0)
    % Hot case 
T = Tmax + 273;
qint = Qmax;

Aradiator = eq_temp_hot(alphaTIR,T, ...
    alphaVNIR, e, ep, Tp, Rp, h, AU_sun,qint,totalArea,ei,alphaTIRi,alphaVNIRi);

Ainsulator = 0.9*totalArea - Aradiator;
    % Cold case 
qint = Qmin;
Tcold = eq_temp_cold(Aradiator,alphaTIR, ...
    alphaVNIR, e, ep, Tp, Rp, h, AU_sun,qint,totalArea,ei,alphaTIRi,alphaVNIRi);

if Tcold > Tmin + 283
    if Aradiator < 0.5*totalArea 
    passive = true;
    end
end


%% SEMI - ACTIVE (add heater)

if ~passive

    % Cold case (eclipse)
T = Tmin + 273;

P_heater = eq_temp_heater(Aradiator,alphaTIR,...
    alphaVNIR, e, ep, Tp, Rp, h, AU_sun,T,totalArea,ei,alphaTIRi,alphaVNIRi,Qmin);

power_TCS = P_heater;
end

power_TCS = 5; %minimum heater in case code decides total passive
%% Mass

M_insulation = 0.73*Ainsulator;
M_electronics = 0.2;
M_radiator = 3.3 * Aradiator;

%mass of heaters depends a lot on the pipes distribution and length of each
%spaceraft (0.15 kg/m)

mass_TCS = M_insulation + M_electronics + M_radiator;

if passive == 1
    TCS_type = 1.0;
else
    TCS_type = 0.0;
end

