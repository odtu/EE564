%% EE564 First Project: Transformer Design a for X-Ray Device
%% ID
%%
% *NAME :* Mehmet Kaan Mutlu
%  
% *STUDENT NUMBER :* 2121408
%  
% *E-mail :* kaan.mutlu@metu.edu.tr

function []=meka_mutlu_XRAY()

%% Specifications 
%%
%
% 
% * *Single Phase, High Frequency High Voltage Transformer*
% * *Primary Winding Voltage:* ± 417 V (peak to peak 834 V for pulsing)
% * *Secondary Winding Voltage:* ± 12.5 kV (peak to peak 25 kV for pulsing) 
% * *Rated Power:* 30 kW (for maximum 100 millisecond) 
% * *Switching Frequency:* Minimum 100 kHz
% * *Ambient Temperature:* 0-40 °C
Prated      = 30e3;
fs          = 100e3;
%%
Vp_peak     = 417;
Vp_fund_peak= Vp_peak*4/pi;
Vp_f_rms    = Vp_fund_peak/sqrt(2);
%%
Vs_peak     = 12.5e3;
Vs_fund_peak= Vs_peak*4/pi;
Vs_f_rms    = Vs_fund_peak/sqrt(2);
%%
Ip_rms      = Prated/Vp_f_rms;
Is_rms      = Prated/Vs_f_rms;

%% Choosing Initial Material

%%
% First step of transformer design is selecting an appropriate core
% material. After some researches on internet and company application 
% guides, it is decided to use a ferrite material for XRAY transformer 
% application at 100kHz switching frequency.
%  
% After this decision, Magnetics' ferrite catalog is read and different
% types of materials are compared. In that comprasion, power losses of
% materials at 25°C and 100kHz is used as basic elimination parameter and
% it is decided to use T material. It is possible to find its parametets
% below:
%
% <<Tmaterial.PNG>>
%

%% Choosing Operation Flux Density

%%
% For the second phase of design, it is going to be choosen operation flux
% density. T material's saturation flux density is 470mT for this project's
% defined temperature range. Our value should be smaller than saturation
% point. But how much? Let's consider over the formula below:
% 
% $e = -\frac{2*\pi}{\sqrt{2}}N2{\pi}fB_{peak}*A$
% 
% If only selectable parameters are considered, it is possible to see the
% trade-off between number of turns, flux density and area. Selecting high 
% number of turns come with dificulties of cabling and copper losses. Cable
% size is decided over current values so it is constant in this discussion.
% Area is important for transformer's size and weight values. It also
% effects cable length and core loss (over weight). Flux density is
% directly related with core losses. 
%  
% As B is increased, core loss is increased (nonlinearly). If we take BxA 
% value constant, then increasing B will decrease A and therefore volume 
% and weight will be less and it means less core loss. So here, by assuming 
% area and weight are proportional, an optimization will be made over core 
% loss.

%% Determination of Core Dimensions & Number of turns

%%
% Comments
%
%

%% Determination of Core and Copper Losses

%%
% Comments
%
%

%% Determination of  Operating Temperature

%%
% Comments
%
%

%% Determination of mass, cost etc.


%%
% Comments
%
%
end