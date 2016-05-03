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
