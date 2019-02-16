% Structural design 

%% INPUTS
% Dimensions
% L = 10; % m 
% D = 2; % m
% mass = 2000; % (kg) satellite wet mass (launch)
% 
% 
% % Load factors during launch
% LFaxial = 2.5 + 4;
% LFlateral = 3;
% LFbending = 3;
% 
% % Natural frequencies
% NF_axial = 25; %Hz
% NF_lateral = 10; %Hz
% 
% % Safety Factors
% SFu = 1.25; %ultimate load
% SFy = 1.1; % yield load
% 
% % Material - Aluminium 7075
% E = 71e9; % N/m^2
% v =0.33;
% rho = 2.8e3;
% Fu = 524e6; %ultimate tensile strength
% Fy = 448e6; % yield tensile strength (plastic deformation)
%% Monocoque structure - cylinder approx of satellite
g = 9.81;
% Axial rigidity
A = mass*L/E*(NF_axial/0.25)^2; %area
t1 = A/(2*pi*(D/2)); %thickness for axial mode

%Lateral rigidity
I = mass*L^3/E*(NF_lateral/0.56)^2; %area moment of inertia
t2 = I/(pi*(D/2)^3); %thickness for bending mode

% Limit loads applied
AxialLoad = mass*g*LFaxial;
LateralLoad = mass*g*LFlateral;
BendingLoad = mass*g*L/2*LFbending;

% Equivalent axial load
Peq = AxialLoad + 2*BendingLoad/(D/2);
UltimateLoad = Peq*SFu;
YieldLoad = Peq*SFy;

%Tensile strength
t3 = UltimateLoad/(2*pi*(D/2)*Fu);

%Yield Strength
t4 = YieldLoad/(2*pi*(D/2)*Fy);

%Buckling load - stability
tvector = [t1 t2 t3 t4];
t = max(tvector); % we use the most critical thickness
phi = 1/16*((D/2)/t)^0.5;
gamma = 1 - 0.901*(1 - exp(-phi));
sigma_cr = 0.6*gamma*E*t/(D/2); % critical buckling stress
A = 2*pi*(D/2)*t; %area new

Pcr = A*sigma_cr; %Critical Buckling Load

%Margin of safety
MS = Pcr/UltimateLoad -1; % if MS < 0, increase thickness

while MS < 0
    t_new = t + 5e-5;
    phi = 1/16*((D/2)/t_new)^0.5;
    gamma = 1 - 0.901*(1 - exp(-phi));
    sigma_cr = 0.6*gamma*E*t_new/(D/2); % critical buckling stress
    A = 2*pi*(D/2)*t_new; %area new
    Pcr = A*sigma_cr; %Critical Buckling Load
    MS = Pcr/UltimateLoad -1; % if MS < 0, increase thickness
    t = t_new;
end

mass_monocoque = rho*2*pi*(D/2)*t*L;

%% Skin Stringer structure

s = 12; %number of stringers
bays = 10; %number of separations of the cylinder (bays)
f = bays + 1; %number of frames
theta = 360/s; %angle of separation between stringers
d = []; %distance from neutral axis to stringer
for i = 1:s
    d(i) = (D/2)*abs(sin(pi/180*theta*(i-1)));
end

tacoustic = 0.00127; % standard skin thickness adequate against acoustic noise
%Axial rigidity
if tacoustic < t1
    tacoustic = t1; % increase limit to axial
end

% Bending rigidity
Iskin = pi*(D/2)^3*tacoustic;
Istr = I - Iskin;
if Istr > 0
d2 = sum(d.^2); %Ixx = sum(Icm + A*d^2);
Astringer = Istr/d2;

%Panel stability - buckling
b = 2*pi*(D/2)/s; %width of the panels
k_panel = 55; %SMAD fig 11-35
sigma_cr_s = k_panel*pi^2*E/(12*(1-v^2))*(tacoustic/b)^2;

A_s = 12*Astringer + 2*pi*(D/2)*tacoustic;
Pcr_s = sigma_cr_s * A_s;

%Margin of safety
MS = Pcr_s/UltimateLoad -1; % if MS < 0, increase thickness
t_s = tacoustic;
while MS < 0
    disp(t_s);
    t_new_s = t_s + 5e-5; %increase panel thickness
    sigma_cr_s = k_panel*pi^2*E/(12*(1-v^2))*(t_new_s/b)^2;
    Astringer = 1/12*(A_s -  2*pi*(D/2)*t_new_s); % decrease stringer area to maintain total area
    Pcr_s = sigma_cr_s * A_s;
    MS = Pcr_s/UltimateLoad -1; % if MS < 0, increase thickness
    t_s = t_new_s;
end

mass_stringers = A_s*L*rho*1.25; %extra 25% for ring frames and fasteners
else 
    mass_stringers = 1e8;
end

%% Solar array substrate

% Input
% SA_mass_total = 20;
% SA_area = 8;
% number_SA = 2;

SA_unit_area = SA_area/number_SA;
SA_mass = SA_mass_total/number_SA; %mass of 1 solar array
l = 10; %slenderness ratio of individual solar array (length/wide)
width = (SA_unit_area/l)^0.5;
length = SA_unit_area/width;
% Natural frequencies have to be 2 times higher than primary structure

NF_axial_SA = NF_axial*2;
NF_lateral_SA = NF_lateral*2;

% Limit loads applied
AxialLoad = SA_mass*g*LFaxial;
LateralLoad = SA_mass*g*LFlateral;
BendingLoad = SA_mass*g*length/2*LFbending;

% Axial rigidity
A = SA_mass*length/E*(NF_axial/0.25)^2; %area transversal
t1 = A/width; %thickness for axial mode

%Lateral rigidity
I = SA_mass*length^3/E*(NF_lateral/0.56)^2; %area moment of inertia
t2 = 12*I/(width^3); %thickness for lateral mode

% Equivalent axial load
Peq = AxialLoad + 2*BendingLoad/(D/2);
UltimateLoad = Peq*SFu;
YieldLoad = Peq*SFy;

%Tensile strength
t3 = UltimateLoad/(2*pi*(D/2)*Fu);

%Yield Strength
t4 = YieldLoad/(2*pi*(D/2)*Fy);

tvector = [t1 t2 t3 t4];
t = max(tvector); % we use the most critical thickness

mass_SA = number_SA*rho*width*length*t;
