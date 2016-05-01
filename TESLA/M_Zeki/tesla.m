p_rated=270000 ;  %Watts
speed_max=155; % max speed in mph
speed_max=speed_max*1.61 ; % kmh
gear_ratio=9.73 ;

%wheel rpm calculation
d_tire=27.7 ; % diameter of tire is 27.7"
d_tire=27.7*2.54/100 ; % diameter in m
p_tire=d_tire*pi ;  % perimeter of tire in m
p_tire=p_tire/1000 ; % perimeter of tire in km
wheel_rph=speed_max/p_tire ; % round per hour
wheel_rpm=wheel_rph/60 ; % round per hour
wheel_rpm=floor(wheel_rpm) 

%electric motor rpm
motor_rpm=wheel_rpm*gear_ratio ;
motor_rpm=round(motor_rpm)


