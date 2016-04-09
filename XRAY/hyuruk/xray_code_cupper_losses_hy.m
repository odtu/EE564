% cupper losses will be calculated
% length of one turn coil will be calculated as follow
% primary and secondary window area assumed equal
% radius of the coil, radius_acoil = C/2 + D/2; [mm]
% length of the coil, length_acoil = 2 * pi * radius_acoil
% where C, D see dimensions
% total coil length:
% for primary side Np * length_acoil * 10^-3
% for secondary side Ns * length_acoil * 10^-3

Icarry_cap_AWG26 = 0.361;       %[A] current rate for the AWG26 size cable
area_AWG26 = 0.129;             % [mm^2]
ohm_AWG26 = 0.13386;            % [Ohm/m]
Icarry_cap_AWG26_J = J * area_AWG26; % [A] current rate by considering J value
C = 25.4;       % dimensions of the core [mm]
D = 31.7;       % dimensions of the core [mm]
radius_acoil = C/2 + D/2;   % [mm]
length_acoil = 2 * pi()* radius_acoil;  % [mm]

% primary side loss calculation
Nstrand_pri = ceil(Ip / Icarry_cap_AWG26);  % number of AWG26 size cable
tot_length_coil_pri = round(Np) * length_acoil * 10^-3; % [m]
res_coil_pri = ohm_AWG26 * tot_length_coil_pri / Nstrand_pri;   % [ohm]
loss_coil_pri = Ip^2 * res_coil_pri;       % [W]

% secondary side loss calculation
Nstrand_sec = ceil(Is / Icarry_cap_AWG26);  % number of AWG26 size cable
tot_length_coil_sec = round(Ns) * length_acoil * 10^-3; % [m]
res_coil_sec = ohm_AWG26 * tot_length_coil_sec / Nstrand_sec;   % [ohm]
loss_coil_sec = Is^2 * res_coil_sec;       % [W]

tot_loss_cupper = loss_coil_pri + loss_coil_sec;    %[W]
%%%%%%


