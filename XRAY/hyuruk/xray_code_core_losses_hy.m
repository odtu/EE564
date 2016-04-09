% core losses will be calculated as follows
% volume of the core: 
% Volume = ((A*2B*C) - (2D*E*C)) * 10^-3  [cm^3]
% core loss mW/cm^3 will be determined 
% @operating B, @operating f, @operating temperature

Vol_core  = ((A_dim*2*B_dim*C_dim) - (2*D_dim*E_dim*C_dim)) * 10^-3;    %[cm^3]
graph_core_loss_100deg = 350;   %[mW/cm^3]
graph_core_loss_40deg = graph_core_loss_100deg * 2; %[mW/cm^3]
core_loss = Vol_core * graph_core_loss_40deg * 10^-3;   %[W]
%%%%%%


