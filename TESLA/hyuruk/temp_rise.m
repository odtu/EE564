% Based on the The Induction Machine Handbook Chapter 14 & 15
% a coarse verification of temperature rise is given here
aconv1 = 50; % [W/m^2.K] IM with selfventilators (below 100Kw) (eq. 15.123)
            % it is not enough to cool
% http://www.engineersedge.com/thermodynamics/overall_heat_transfer-table.htm
% forced water cooling heat transfer structure should be used
aconv2 = 650; % [W/m^2.K]
acond = 833; % [W/m^2.K] slot insulation conductivity (eq. 15.124)
Als = (2*hs+bs2)*L*Ns;  % [m^2] stator slot lateral area (eq. 15.125)
Kfin = 3;   % [-] finn factor (eq. 15.126)
Aframe = pi*Dout*(L+pole_pitch)*Kfin; % [m^2] frame area including finn area
                                      % (eq. 15.126)
delta_co = Pco/(acond*Als);  % [°] temperature differential between conductors
                             % in slots and the slot wall (eq. 15.121)

delta_frame2 = Ploss_total/(aconv2*Aframe); % [°] frame temperature rise
                             % with respect to ambient air (eq. 15.122)
delta_frame1 = Ploss_total/(aconv1*Aframe); % [°] frame temperature rise
                             % with respect to ambient air (eq. 15.122)
                             
temp_ambient = 40; % [°] ambient temperature
temp_co = temp_ambient+delta_frame2+delta_co; % [°] winding temperature
                                             % (eq. 15.127)           
                                             % should be <80°
                                             
                             