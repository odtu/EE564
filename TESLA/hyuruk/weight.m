% Based on the The Induction Machine Handbook Chapter 14 & 15
% motor weight will be determined
Gyr = yiron*pi/4*((Dis-2*hcr)^2-Dshaft_max^2)*L*Kfe; % [kg] rotor back iron yoke
                                               % weight
weight_rotor = Gtr + Gyr; % [kg] rotor iron weight                                              
weight_stator = Gy1 + Gt1; % [kg] stator iron weight
Kshaft = 1.35; % [-] to connect the load to the shaft there should be 
              % available space outside of the shaft
weight_shaft = yiron*pi/4*(Dshaft_max^2)*L*Kfe*Kshaft; % [kg]shaft iron weight

ycopper = 8960; % [kg/m^3] density
weight_sta_co = ycopper*m*N_per_ph_req*lc*Aco*10^-6*a1; % [kg] copper weight

yaliminium = 2700; % [kg/m^3] density
weight_rot_al = yaliminium*Nr*(Ab*L+Aer*ler); % [kg] rotor aliminum bar weight

weight_total = weight_rotor+weight_stator+weight_shaft+weight_sta_co+weight_rot_al;
% note that cooling and outside frame and other accessories are not
% included!

Grotor = weight_rotor + weight_shaft + weight_rot_al;   % [kg] total rotor loss
  
inertia_rotor = 0.5*Grotor*(Dis/2)^2; % [kg.m^2] rotor inertia

