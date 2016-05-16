% Based on the The Induction Machine Handbook Chapter 14 & 15
%losses and efficiency will be calculated
Pco = 3*Rs*Iph_rated_rms^2; % [W] stator winding losses
Pal = 3*Rrpsn*Ki^2*Iph_rated_rms^2; % [W] rotor cage losses (eq. 15.97)
Pmv = 0.012*power_rated*10^3; % [W] mechanical/ventilation losses for p1=2
Pstray = 0.01*power_rated*10^3; % [W] stray losses 
yiron = 7800;
Gt1 = yiron*Ns*bts*(hs+hws+hos)*L*Kfe; % [kg] stator tooth weight
Kt = 1.7;   % [-] (eq. 15.98) core loss augmentation
p10 = 2.5;  % [W/kg} specific losses in W/kg at 1.0 Tesla and 50Hz
Pt1 = Kt*p10*(f1/50)^1.3*Bts^1.7*Gt1; % [W] stator teeth fund. losses 
                                      % (eq. 15.98)
Gy1 = yiron*pi/4*(Dout^2-(Dout-2*hcs)^2)*L*Kfe; % [kg] stator back iron weight
                                      % (eq. 15.101)
Ky = 1.75; % [-] influence of mechanical machining
Py1 = Ky*p10*(f1/50)^1.3*Bcs^1.7*Gt1; % [W] stator back iron (yoke) losses 
                                      % (eq. 15.100)
Piron1 = Pt1+Py1;   % [W] fund. iron losses
Kps = 1/(2.2-Bts);  % [-] (eq. 15.104)
Kpr = 1/(2.2-Btr);  % [-] (eq. 15.104)
Bps = (Kc2-1)*Bg_req; % [Tesla] (eq. 15.105)
Bpr = (Kc1-1)*Bg_req; % [Tesla] (eq. 15.105)

Gtr = yiron*Nr*btr*(hr+hwr+hor)*L*Kfe; % [kg] rotor teeth weight 

Pirons = 0.5*10^-4*((Nr*f1/p1*Kps*Bps)^2*Gt1+(Ns*f1/p1*Kpr*Bpr)^2*Gtr);
                      % [W] tooth flux pulsation core loss constitutes
                      % the main components of stray losses (eq. 15.103)
Piron = Pirons+Piron1; % [W] total iron core loss
Ploss_total = Pco+Pal+Piron+Pmv+Pstray; % [W] total losses (eq. 15.95)
neff_cal = power_rated*10^3/(power_rated*10^3+Ploss_total); % [-]
                                        % efficiency (eq. 15.94)
                                        
