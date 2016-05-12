% Based on the The Induction Machine Handbook Chpater 14 & 15
neff = 0.96;             % [-] targetted efficiency (IE3)
pwr_factor = 0.88;       % [-] typ. power factor for induction motors 
                         % at full load varies between 0.85-0.90
Ke = 0.98 - 0.005*p1;    % [-] Ke defined as E1 / V1n (eq. 14.8)
                         % and approx. given as eq. 14.10
Sgap = Ke * power_rated * 10^3 / (neff * pwr_factor);  % [VA] (eq. 15.2)
stack_aspect = 1.25;      % [-] stack aspect ratio define as 
                         % stack length to pole pitch ratio (eq. 14.19)
                         % (table 15.1)
Co = 250*10^3;           % [J/m^3] extracted from figure 14.14
Dis = ((2*p1*p1*Sgap)/(pi()*stack_aspect*f1*Co))^(1/3); %[m] (eq. 15.1)
pole_pitch = pi()*Dis/(2*p1);   % [m] pole pitch (eq. 15.2)
L = stack_aspect * pole_pitch;  % [m] stack length (eq. 15.2)
Ftan_max = torque_max / (Dis/2);% [N] tangential force
Sr = pi()*Dis*L;                % [m^2] surface area 
shear_stress_max = Ftan_max / Sr; % [N/m^2], [Pascal] tangential shear stress
Cmech = power_max / (Dis^2*L*f1/p1); % [kWs/m^3] specific machine constant
max_stator_num = round(pi()*Dis/0.007); % [-] max. stator number from 
                                        % ee564_basic_machine_design2, 8/23 
min_stator_num = ceil(pi()*Dis/0.045);  % [-] min. stator number
Kd = 0.62;                % [-] for 2p1 pole number (Table 15.2)
Dout = Dis / Kd;          % [m] outer diameter of the stator (eq. 15.4)
g1 = 0.1+0.012*(power_rated*10^3)^(1/3); %[mm] airgap (eq. 15.5)
g2 = 0.18+0.006*(power_rated*10^3)^(0.4);%[mm] airgap from
                                         % ee564_basic_machine_design 16/18
if (g1 > g2)    
    g = g1;
else
    g = g2;
end;
g = g * 1.2;                        % [mm] to add safety factor

   
                                   