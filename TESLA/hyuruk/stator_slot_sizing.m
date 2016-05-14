% Based on the The Induction Machine Handbook Chapter 14 & 15
% stator slot sizing will be determined
Kfill = 0.44;   % [-] slot fill factor for above 10kW
Asu = pi*dcop^2*ap*ns/(4*Kfill); % [mm^2] useful slot area (eq. 15.21)

% see figure stator slot geometry
bos = 2.5*10^-3;      % [m]  
hos = 0.75*10^-3;     % [m]
hw = 2.5*10^-3;       % [m]
Kfe = 0.96;     % [-]
Bts = 1.55;     % [Tesla] stator tooth flux density
sta_slot_pitch = pole_pitch/(3*q);   % [m] stator slot pitch (eq. 15.3)
bts = Bg_req*sta_slot_pitch/(Bts*Kfe); % [m] tooth width  (eq. 15.22)
bs1 = (pi*(Dis+2*hos*+2*hw)/Ns)-bts;   % [m] slot lower witdh bs1 (eq. 15.23)
bs2 = sqrt(4*Asu*10^-6*tan(pi/Ns)+bs1^2);% [m] slot upper witdh bs1 (eq. 15.27)    
hs = 2*Asu*10^-6/(bs1+bs2);            % [m] slot useful height (eq. 15.24) 
Fmg = 1.2*g*10^-3*Bg_req/u0;           % [Aturns] airgap mmf (eq. 15.29)
Hts = 1760;                            % [A/m] (table 15.4)
Fmts = Hts*(hs+hos+hw);                % [Aturns] stator tooth mmf (eq. 15.30)
Fmtr = Kst*Fmg - Fmts;                 % [Aturns] rotor tooth mmf (eq. 15.31)
hcs = (Dout-(Dis+2*(hos+hw+hs)))/2;      % [m] stator back iron height (eq. 15.32)
Bcs = flux_airgap/(2*L*hcs);           % [Tesla] back core flux density (15.33)