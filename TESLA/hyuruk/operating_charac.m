% Based on the The Induction Machine Handbook Chapter 14 & 15
% operating characteristics will be investigated
I0a = (Piron+Pmv+(3*Im^2*Rs))/(3*Vph_rms);  % [A] no load active current
                                            % (eq. 15.109)
Sn = Pal/(power_rated*10^3+Pal+Pmv+Pstray); % [-] rated slip (eq. 15.110)                                      
Tn = power_rated*10^3/(2*pi*(f1/p1)*(1-Sn)); % [Nm] rated shaft torque
                                             % (eq. 15.111)
pwr_factor_cal = power_rated*10^3/(3*Vph_rms*Iph_rated_rms*neff_cal); % [-]
                                            % rated power factor (eq. 15.117)
                                            