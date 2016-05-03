% Input Parameters of the 
% Tesla Model S Induction Motor
power_max = 270;                 % [kW] from project2
torque_max = 440;                % [Nm] from project2
speed_max = 225;                 % [km/sa] from project2
m = 3;                           % [-] three phases
p1 = 2;                          % [-] pole pair from Hendershot-FIU-Lecture
power_rated = 288 * 0.746 ;      % [kW] from Hendershot-FIU-Lecture
tire_diameter = 27.7 * 25.4;     % [mm] from 
                                 % https://tiresize.com/tires/Tesla/Model-S/
                                 % https://tiresize.com/tiresizes/245-45R19.htm
gear = 9.73;                     % [-] 9.73:1 (transmission) from 
                                 % https://en.wikipedia.org/wiki/Tesla_Model_S
speed_rpm_max = (speed_max*10^3/3600)/(tire_diameter*10^-3/2)*(60/2*pi())*gear; % [rpm}
speed_rpm_rated = 6000;          % [rpm] from Hendershot-FIU-Lecture
                                 % approx. knee of the torque-speed curve  
f1 = speed_rpm_rated*2*p1/120;   % [Hz] frequency of the driver unit
            
                                