% Based on the The Induction Machine Handbook Chapter 14 & 15
% resistance and inductances refer to eq. circuit (figure 15.9)
y = pitch_factor*pole_pitch; % [m] coil span (eq. 15.67)
lend = 2*y-0.02;             % [m] coil end connection length (eq. 15.65)
lc = 2*(L+lend);             % [m] coil length (eq. 15.64)
pco_80deg = 2.1712*10^-8;    % [ohm.m] copper resistivity at @80° (eq. 15.69)
Rs = pco_80deg*(lc*N_per_ph_req)/(Aco*10^-6*a1); % [Ohm] stator resistance
                                                 % (eq. 15.63)
lambdaec = 0.34*(q/L)*(lend-0.64*pitch_factor*pole_pitch); 
                             % [-] (eq. 15.79) two-layer, end connection 
                             % specific geometric permeance coefficient
Lec = 2*u0*L*N_per_ph_req^2/(p1*q)*lambdaec; % [H] end winding inductance
                                             % derived from (eq. 15.75)
ler = pi*(Dis-(2*g*10^-3)-(3*10^-3)-b)/Nr;   % [m] end ring segment
                                             % (eq. 15.71 & Dre-Der~=3-4mm
pal_80deg = 3.1*10^-8*(1+(80-20)/273);       % [ohm.m] aluminium resistivity
Rer = pal_80deg*(ler/(2*Aer*sin(pi*p1/Nr)^2)); % [ohm] rotor end ring segment
                                               % derived from (eq. 15.70)

                                                 
