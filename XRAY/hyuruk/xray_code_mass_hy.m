% mass of the transformer will be calculate as follows
% copper mass:
% total length of the copper * copper area * density of the copper
% total mass = total copper mass + total core mass

density_copper = 8.96;      % [g/cm^3]

copper_vol_pri = tot_length_coil_pri * Nstrand_pri * area_AWG26;   %[cm^3]
copper_mass_pri = copper_vol_pri * density_copper * 10^-3;    %[kg]

copper_vol_sec = tot_length_coil_sec * Nstrand_sec * area_AWG26;   %[cm^3]
copper_mass_sec = copper_vol_sec * density_copper * 10^-3;    %[kg]

mass_transformer = copper_mass_pri + copper_mass_sec + core_mass; %[kg]
%%%%%%


