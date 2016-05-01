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
Pmax = 270*10^3;
% * *Maximum Torque:* 441 Nm
% * *Top Speed:* 225 km/h  
% * Corresponding maximum RPM value is 21848 RPM. This value is calculated
% by considering Tesla Model S has 21' tires and 9.73 to 1 gear ratio.
%%
% Except for these given specs, these are also found from internet:
% 
% * *Number of poles:* 4
p = 4;
% * *Number of phases:* 3
% * *Line supply voltage:* 320 V
% * *Rated Power:* 185 kW
Prated = 185*10^3;

Aimed_eff = 0.9;
Aimed_pf = 0.9;

%% Main Dimensions of Stator Core

%%
% 

Ke = 0.98- 0.005*p;
Sgap = Ke*Prated/(Aimed_eff*Aimed_pf);

%%
end