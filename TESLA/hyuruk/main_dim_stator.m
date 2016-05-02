% Based on the The Induction Machine Handbook Chpater 14 & 15
neff = 0.96;             % [-] targetted efficiency (IE3)
pwr_factor = 0.88;       % [-] typ. power factor for induction motors 
                         % at full load varies between 0.85-0.90
Ke = 0.98 - 0.005*p1;    % [-] Ke defined as E1 / V1n (eq. 14.8)
                         % and approx. given as eq. 14.10
Sgap = Ke * power_rated * 10^3 / (neff * pwr_factor);  % [VA] (eq. 15.2)
stack_aspect = 1.5;      % [-] stack aspect ratio define as 
                         % stack length to pole pitch ratio (eq. 14.19)
                         % (table 15.1)
Co = 240*10^3;           % [J/m^3] extracted from figure 14.14
Dis = ((2*p1*p1*Sgap)/(pi()*stack_aspect*f1*Co))^(1/3); %[m] (eq. 15.1)
pole_pitch = pi()*Dis/(2*p1);   % [m] pole pitch (eq. 15.2)
L = stack_aspect * pole_pitch;  % [m] stack length (eq. 15.2)

 