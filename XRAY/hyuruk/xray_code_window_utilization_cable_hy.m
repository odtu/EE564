% Approximately primary and secondary wire size are can be calculated
% as follows:
% Ku * Wa = Np*Awp + Ns*Aws
% Ku is fill factor
% Ku = s1*s2*s3*s4
% s1: wire isulation,  conductor area/wire area 
% s2: fill factor,  wound area/usable window area
% s3: effective window, usable window area/window area
% s4: insulation factor, sable window area/usable window area + insulation  
% Note that at 100Khz to minimize skin effect AWG26 is used
% for more details see below link
% http://coefs.uncc.edu/mnoras/files/2013/03/
% Transformer-and-Inductor-Design-Handbook_Chapter_4.pdf
% assume
% Np*Awp = 1.1 * Ns*Aws (to allow for losses)

% for AWG26 @100kHz
s1 = 0.79;             
s2 = 0.61;
s3 = 0.6;
s4 = 1;
Ku = s1*s2*s3*s4;

Aws = Ku * Wa * 10^2 / (2.1 * ceil(Ns));   % [mm^2]
Awp = 1.1 * ceil(Ns) * Aws / round(Np);          % [mm^2]
    
% mm^2   %requirred wire size for choosen current density 
Awp_req = Ip / J;      
Aws_req = Is / J;      

%%%%%%


