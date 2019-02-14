% subsystem2 are executed after the solver, because use results from it

%% Solar array mass
mass_sa = P_density_eol*Asa/spec_power_sa;
P_bol = P_density_bol*Asa;
P_eol = P_density_eol*Asa;
%% Others
mass_others = (0.02+0.025)*P_density_bol*Asa + 0.02*dry_mass;

%% EPS mass
mass_EPS = mass_sa + mass_batt + mass_others;

