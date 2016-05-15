%% EE564 First Project II: TESLA Model S Induction Motor
%% ID
%%
% *NAME :* Mehmet Kaan Mutlu
%  
% *STUDENT NUMBER :* 2121408
%  
% *E-mail :* kaan.mutlu@metu.edu.tr

function []=meka_mutlu_TESLA()

%% Specifications 
%%
% In this project, design of the induction motor that is used in *Tesla
% Model S*. Normally it has different variations, to  keep things simple;
% *RWD 85 Model* will be used that has the following specs: 
%  
% * *Maximum Power:* 270 kW
Pmax = 270*10^3; % [W]
%%
% * *Maximum Torque:* 441 Nm
% * *Top Speed:* 225 km/h  

%%
% Except for these given specs, these are also found from internet:
%  
% * *Number of poles:* 4
p = 4/2; %pole_pairs
%%
% * Maximum RPM value of our motor is 21848 RPM. This value is calculated
% by considering Tesla Model S has 21' tires and 9.73 to 1 gear ratio.
Spd_rpm_max = 21848; %[RPM]
%%
%  
% If we assume average speed is 85 km/h. Then rated RPM value of motor will
% be 7960 RPM.
Spd_rpm_rated = 7960; %[RPM]
f_rated = Spd_rpm_rated*p/60;
%%
%  
% * *Number of phases:* 3
% * *Line supply voltage:* 320 V
% * *Rated Power:* 185 kW
Prated = 185*10^3; % [W]

%% Main Dimensions of Stator Core

%%
% Boldea's The Induction Machine Handbook is going to be used to determine
% parameters and dimensions of motor. In Chapter 15, it is explained that
% $D_{is}^2L$ output constant concept will be used. For internal stator
% diameter formula below will be used:
%  
% $D_{is}^{3} = \frac{2pp_1S_{gap}}{\pi \lambda fC_0}$
%  
% To be able to calculate $D_{is}$, airgap power is needed.
Aimed_eff = 0.95;
Aimed_pf = 0.85;
fprintf('At this point targeted efficiency is taken as %2.0f %%.',Aimed_eff*100)
%% 
fprintf('Power factor is taken as %0.2f %.',Aimed_pf)

%%
% Another required parameter to be able to calculate airgap power is Ke
% that is defined as E1 to Vin ratio in equation 14.8.
%  
% $K_E \approx 0.98 -0.005p_1$
%
Ke = 0.98- 0.005*p;

%%
% Now everything is ready for airgap apparent power:
%  
% $S_{gap} =\frac{K_EP_n}{\eta_ncos\Phi}$
% 
Sgap = Ke*Prated/(Aimed_eff*Aimed_pf);
fprintf('Airgap power is calculated as %3.1f KVA.',Sgap/1000)

%%
% After this calculation, missing parameters are stack aspect ratio and
% Esson's constant Co.
% Stack aspect ratio is selected from table below:
% 
% <<stack_aspect_ratio.PNG>>

stck_asp_ratio = 1.5;
fprintf('It is selected as %1.1f.',stck_asp_ratio)
%%
% Esson's constant is selected using Figure 14.14. 
% 
% <<Essons_constant.PNG>>
%  
% Because our calculated airgap power is out of figure's range it isn't 
% possible to read a certain value but for two pole-pairs after 60 kVA 
% Esson's constant starts to saturate and for our airgap apparent power 
% this value is taken as 240 J/dm^3.

Co=240*10^3; %[J/m^3]
%%
% Now we are ready to calculate internal stator diameter:

Dis = ((2*p*p*Sgap)/(pi*stck_asp_ratio*f_rated*Co))^(1/3);
fprintf('Internal diameter of stator is calculated as %2.3f cm.',Dis*100)
%% 
Dis = (ceil(Dis*1000))/1000;
fprintf('For realistic dimensions it is going to be taken as %2.1f cm.',Dis*100)
%%
% Now we can calculate stack length, deriving its formula from equation
% 15.2:
% 
% $L = \frac{\lambda \pi D_{is}}{2p}$

L = stck_asp_ratio*pi*Dis/(2*p);
fprintf('Stack length L is %2.2f cm.',L*100)
%%
L = (ceil(L*1000))/1000;
fprintf('For being realistic it is going to be taken as %2.1f cm.',L*100)
%%
% By using equation 14.14 it is possible to calculate the pole pitch:
%  
% $\tau = \frac{\pi D_{is}}{2p}$

pole_pitch = pi*Dis/(2*p);
fprintf('Pole pitch is %2.2f cm.',pole_pitch*100)
%%
% Next step is deciding external stator diameter. For its calculation,
% table below will be used.
% 
% <<Dout_ratio.PNG>>
% 
% It gives us information about ratio of internal and external stator
% diameters. For 4 poles this ratio will be taken as 0.62.

Kd = 0.62;
Dout = Dis / Kd;
fprintf('External diameter of stator is calculated as %2.3f cm.',Dout*100)
%%
Dout = (ceil(Dout*1000))/1000;
fprintf('For realistic dimensions it is going to be taken as %2.1f cm.',Dout*100)
%%
% For suitable airgap calculation book's equation of 14.38 may be used as
% well as the equation defined during the EE564 lecture of 6th April. Here
% it is important to remind that the minimum airgap is 0.2 mm.
%  
% Formula discussed in the lecture is as follows:
%  
% $airgap =0.18 + 0.006P^{0.4} mm$
%  
% Book equation of 14.38 is
%  
% $airgap =0.1+ 0.012P^{\frac{1}{3}} mm$
%  
% As known, too small airgap would produces large space airgap field
% harmonics and additional losses while a too large one would reduce the
% power factor and efficiency. Therefore, average of these two calculated
% airgap values will be used as actual airgap value.
g_lecture = (0.18 + 0.006*Prated^0.4)*10^-3;
g_book = (0.1 + 0.012*Prated^(1/3))*10^-3;
g=(g_lecture+g_book)/2;
fprintf('Airgap is calculated as %0.4f mm.',g*1000)
%%
g=(ceil(g*10^5))*10^-5;
fprintf('For being realistic it is going to be taken as %0.2f mm.',g*1000)
%% The Stator Winding

%%
% 




 
%% 
end