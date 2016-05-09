% Based on the The Induction Machine Handbook Chpater 14 & 15
Ns = 2*p1*m*4;          % [-] number of stator slots 
q = Ns/(2*p1*m);        % [-] slots per pole per phase
pitch_factor = 5/6;     % [-] to minimize 5th and 7th harmonics
pitch_angle = 5/6*180;  % [°] pitch angle
slot_angle_alpha = 180/(Ns/(2*p1)); % [°] slot angle (eq. 15.7)
Kp1 = sind(pitch_angle/2); % [-] fundamental pitch factor (eq. 15.9)
Kd1 = sind(q*slot_angle_alpha/2)/(q*sind(slot_angle_alpha/2));
                           % [-] fundamental distribution factor (eq. 15.8)
Kw1 = Kp1*Kd1;             % [-] fundamental winding factor
Bg = 0.7;               % [Tesla] (e.q. 15.11)
den_shape = 0.729;  % [-] density shape factor fig.14.13, where 1+Kst=1.4
Kf = 1.085;         % [-] form factor fig.14.13
flux_airgap = den_shape*pole_pitch*L*Bg; %[Wb] airgap flux (eq. 5.10)
ma = 1.0;           % [-] PWM mod. index of the inverter, linear region
Vph_rms = ma*Vd/2*(1/sqrt(2)); %[V] (eq. 8.56 Mohan) rms phase voltage
N_per_ph = Ke*Vph_rms/(4*Kf*Kw1*f1*flux_airgap); % [turns/phase] (eq. 15.12)
a1 = 1;             % [-] the number of current path in parallel
ns = a1*N_per_ph/(p1*q); % [*] the number of conductors per slot
if ns<=2 
    ns = 2;
else
    if 1 == mod(ceil(ns),2)
        ns = ns +1;
    end
end
N_per_ph_req = p1*q*ns;
Bg_req = Bg * N_per_ph/N_per_ph_req;
