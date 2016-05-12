% Based on the The Induction Machine Handbook Chpater 14 & 15
Ns = 2*p1*m*4;          % [-] number of stator slots 
q = Ns/(2*p1*m);        % [-] slots per pole per phase
pitch_factor = 5/6;     % [-] to minimize 5th and 7th harmonics
pitch_angle = 5/6*180;  % [°] pitch angle
slot_angle_alpha = 180/(Ns/(2*p1)); % [°] slot angle (eq. 15.7)
Kp1 = sind(pitch_angle/2); % [-] fundamental pitch factor (eq. 15.9)
Kd1 = sind(q*slot_angle_alpha/2)/(q*sind(slot_angle_alpha/2));
                        % [-] fundamental distribution factor (eq. 15.8)
Kw1 = Kp1*Kd1;          % [-] fundamental winding factor
Bg = 0.65;              % [Tesla] (e.q. 15.11)
den_shape = 0.729;      % [-] density shape factor fig.14.13, where 1+Kst=1.4
Kf = 1.085;             % [-] form factor fig.14.13
flux_airgap = den_shape*pole_pitch*L*Bg; %[Wb] airgap flux (eq. 5.10)
Vph_rms = 4/pi()*Vd/2*(1/sqrt(2)); %[V] (eq. 8.56 Mohan) rms phase voltage
N_per_ph = Ke*Vph_rms/(4*Kf*Kw1*f1*flux_airgap); % [turns/phase] (eq. 15.12)
a1 = 1;                 % [-] the number of current path in parallel
ns = a1*N_per_ph/(p1*q);% [*] the number of conductors per slot
% to get even number conductors because of double layer winding
if ns<=2 
    ns = 2;
else
    ns = ceil(ns);
    if 1 == mod(ns,2)
        ns = ns +1;
    end
end
N_per_ph_req = p1*q*ns;         % [turns/phase] required turns/phase   
Bg_req = Bg * N_per_ph/N_per_ph_req; % [Tesla] required Bg
Vll_rms = Vph_rms * sqrt(3);    % [V] line-line rms voltage
Iph_rated_rms = power_rated*10^3/(neff*pwr_factor*sqrt(3)*Vll_rms);
                                % [A] rated phase current (eq. 15.16)
Jcos = 5.5;            % [A/mm^2] current density for 2p1=2,4 (eq. 15.17)
Aco = Iph_rated_rms/(Jcos*a1);  % [mm^2] stator wire cross section
dco = sqrt(4*Aco/pi);  % [mm] wire gauge diameter (eq. 15.19)
ap = 4;                % [-] number of conductor in parallel
dcop = sqrt(4*Aco/(pi*ap)); % [mm] wire gauge diameter (eq. 15.20)
dcop_sta = 5.189;      % [mm] AWG4 size is chosen by regarding above value                                
                                

