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
f_rated = round(Spd_rpm_rated*p/60);
fprintf('In this case supply frequency will be %d Hz.',f_rated)
%%
% * *Number of phases:* 3
m = 3;
%%
% * *Line supply voltage:* 400 V
Vline = 400;
%%
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
Aimed_pf = 0.89;
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
% diameters. For 4 poles this ratio will be taken as 0.61.

Kd = 0.61;
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
% Following James Hendershot's lecture notes, for 4 poles and 185 kW of
% rated power Stator slot number will be selected. Our rated power is
% nearly 250 HP and from table below, it is advised to choose 58 stator
% slots for our case.
%  
% <<Ns.PNG>>
%  
% Here we should remember that the total number of slots per stator should
% be divisible by the number of phases. So it should be a number that is
% multiple of 3.
%  
% $q = \frac{N_s}{2pm}$ 
%  
% If we think about its formula above (taken from book; 4.7), it is 
% possible to see that choosing Ns/m integer doesn't guarantee that q is 
% an integer. In fact it doesn't have to be an integer and may be selected 
% as a fraction. But in most induction machines, q is an integer to 
% provide complete (pole to pole) symmetry for the winding. So in our case 
% Ns must be multiple of 2pm=12. Advised number is 58, so Ns would be taken 
% as 60. It was tried and seen that number of conductors, flux density and 
% other parameteres don't meet the expectations. So it is going to be taken
% as 48.
Ns = 48;
q = Ns/(2*p*m);
fprintf('Number of slots per pole per phase is %d .',q)
%%
% Now we should decide pitch factor. It can be selected as 5/6 to reduce
% 5th harmonic and reduce 7th harmonics. So two layered winding  with 
% chorded coils will be used.
pitch_factor = 5/6;
ang_pitch = pitch_factor*180; % [degree]
ang_pitch_rad = pitch_factor*pi; % [radian]
fprintf('Selected pitch angle is %d degree .',ang_pitch)
%%
% It is possible to calculate the electrical angle between emfs in 
% neighboring slots $\alpha_{ec}$
%  
% $\alpha_{ec}=\frac{2 \pi p}{N_s}$
ang_electrcl_rad = 2*pi*p/Ns;
ang_electrcl_deg = ang_electrcl_rad/pi*180;
fprintf('It is %0.3f radian means %d degree.',ang_electrcl_rad,ang_electrcl_deg)
%%
% Now we can calculate pitch factor. Due to chorded coils of stator,induced 
% voltage will drop but by means of harmonics we will have better results.
%  
% $k_p = sin(\frac{\lambda}{2})$
%  
kp = sin(ang_pitch_rad/2);
fprintf('Pitch factor is calculated as %0.2f .',kp)
%%
% Using formula below it is possible to calculate distribution factor.
%  
% $k_d = \frac{sin(q\frac{\alpha}{2})}{qsin\frac{\alpha}{2}}$
%  
kd = sin(q*ang_electrcl_rad/2)/(q*sin(ang_electrcl_rad/2));
fprintf('Distribution factor is calculated as %0.2f .',kd)
%%
% Multiplicaiton of distribution and pitch factors are called as winding
% factor.
kw = kp * kd;
fprintf('Winding factor is calculated as %0.2f .',kw)
%%
% Using recommended intervals given in 15.11, it is possible to select the
% airgap flux density. For 4 poles suggested interval is 0.65 to 0.78
% Tesla. To decrease iron losses minimum of this interval will be taken as
% airgap flux density.
Bg = 0.7 %[T]
%%
% The pole coefficient $\alpha_i$ and form factor Kf depend on the tooth 
% saturation factor 1+Kst. If 1+Kst is taken as 1.4 than Kst is 0.4.
Kst = 0.4;
%%
% Using this value and graph below, it is possible to select form factor
% and flux density shape factor.
%  
% <<kf_alphai.PNG>>
%  
alpha_i = 0.729;
kf = 1.085;
fprintf('Form factor is selected as %1.3f .',kf)
%%
fprintf('Flux density shape factor is selected as %0.3f .',alpha_i)
%%
% Using these coefficients it is possible to calculate pole flux.
%  
% $\phi = \alpha_i \tau L B_g$
% 
pole_flux=alpha_i*pole_pitch*L*Bg; % [Wb]
fprintf('Pole flux is calculated as %1.3f mWb.',pole_flux*1000)
%%
% The number of per phase can be calculated using formula below given with
% (15.12).
%  
% $N_{ph} = \frac{K_EV_{ph}}{4K_fK_wf\phi}$
% 
Nph = Ke*(Vline/(sqrt(2)))/(4*kf*kw*f_rated*pole_flux);
fprintf('The number of turns per phase is calculated as %3.1f turns/phase.',Nph)
%%
% The number of conductors per slot ns can be calculated using formula
% below:
%  
% $n_s = \frac{a_1N_{ph}}{p_1q}$
%  
% Here a1 ise the number of current paths in parallel and will be taken as
% 1 for our case.
ns = Nph/(p*q);
fprintf('It is calculated as %1.2f .',ns)
%%
% It should be an even number as there are two distinct coils per slot in a
% double layer winding. So ns is selected as 2.
ns = 2;
%%
% If we turn back and recalculate the actual airgap flux density:
Bg = Bg*Nph/(ns*p*q);
fprintf('Recalculated airgap flux density is %1.3f T .',Bg)
%%
% Now we can calculate rated current. 15.16 formula will be used:
%  
% $I_{in} = \frac{P_n}{\eta cos\phi_n \sqrt{3}V_1}$
Iin_rated = Prated/(Aimed_eff*Aimed_pf*sqrt(3)*Vline);
fprintf('Rated phase current is calculated as %3.1f A .',Iin_rated)
%% 
% To be able to calculate wire cross section, current density will be
% selected first. Here, recommendation 15.17 will be followed and for 4
% poles current density will be taken as 6 A/mm^2.
Jcos = 6;
%%
% 
% $A_{co} = \frac{I_{in}}{J_{cos}}$
Aco = Iin_rated/Jcos; % [mm^2]
fprintf('Magnetic cross section area is calculated as %3.2f mm^2.',Aco)
%%
% Using cross-sectional wire area information it is possible to calculate
% the diameter wire gauge.
%  
% $d_{co} = \sqrt{\frac{4A_{co}}{\pi}}$
%  
dco = sqrt(4*Aco/pi); %[mm]S
fprintf('Wire gauge diameter is %3.2f mm.',dco)
%%
% Because this diameter is not small, 30 conductors will be paralleled to
% decrase the diameter of each conductor.
ap = 30;
dco = sqrt(4*Aco/(ap*pi)); %[mm]S
fprintf('New wire gauge diameter is %3.2f mm.',dco)
%%
% By using table 15.3, it is possible to jump from wire diameter to
% insulated wire diameter.
dco_ins = 1.53*10^-3; % [m]
fprintf('Insulated wire gauge diameter is %3.2f mm.',dco_ins*10^3)
%% Stator Slot Sizing

%% 
end