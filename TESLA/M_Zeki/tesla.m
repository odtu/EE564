p_rated=270000 ;  %Watts
speed_max=225; % kmh
gear_ratio=9.73 ;
pf=0.90;
efficiency=0.95;

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

%V_fundamental calculation
v_battery=375 % V given
v_fund_rms=(v_battery/2)*(4/pi)/sqrt(2) % for one phase
v_fund_rms_linetoline=v_fund_rms*sqrt(3) % line to line voltage

% https://www.youtube.com/watch?v=NaV7V07tEMQ
% pole number is 4 and the phase number is 3.
p=4;
phase=3;







