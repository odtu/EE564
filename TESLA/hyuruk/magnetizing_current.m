% Based on the The Induction Machine Handbook Chapter 14 & 15
% magnetizing current will be determined
y1 = bos^2/(5*g*10^-3+bos);  % [m] (eq. 15.53)
y2 = bor^2/(5*g*10^-3+bor);  % [m] (eq. 15.53)
Kc1 = sta_slot_pitch/(sta_slot_pitch-y1); % [-] (eq. 15.55)
Kc2 = rot_slot_pitch/(rot_slot_pitch-y2); % [-] (eq. 15.56)
Kc = Kc1*Kc2;   % [-] total Carter coefficient Kc
Ccs = 0.88*exp(-0.4*Bcs^2); % [-] subunitary empirical coe. (eq 15.60)
Ccr = 0.88*exp(-0.4*Bcr^2); % [-] subunitary empirical coe. (eq 15.60)
Hcs = 2500;     % [A/m] Hcs value at Bcs (table 15.4)
Hcr = 3460;     % [A/m] Hcs value at Bcs (table 15.4)
Fmcs = Ccs*pi*(Dout-hcs)/(2*p1)*Hcs; 
                % [Aturns] stator back core mmfs (eq. 15.58)

Fmcr = Ccr*pi*(Dshaft_max+hcr)/(2*p1)*Hcr; 
                % [Aturns] rotor back core mmfs (eq. 15.59)                
Flm = 2*(Fmg+Fmts+Fmtr+Fmcs+Fmcr); % [Aturns] magnetizing mmf (eq. 15.52)
Ks = Flm/(2*Fmg)-1; % [-] total saturation factor (eq. 15.61)
Im = pi*p1*(Flm/2)/(3*2^(0.5)*N_per_ph_req*Kw1); % [A] magnetizing current 
                                                 % (eq. 15.62)
im = Im/Iph_rated_rms; % [-] relative (p.u) value of Im (eq. 15.62')                                                 

      