% transformer reluctance, magnetizing inductance will be calculated 
% R = le / (u * Ac)
% Lm = Npri ^2 / R
% H field intensity = B / u
mu0 = 4 * pi() * 10^-7;     %[-]
Reluctance = le_dim * 10^-3 / (mu_r*mu0*Ac*10^-4);
Lm = round(Np)^2 / Reluctance * 10^3;     %[mH]
Lm_Al = Al*round(Np)^2*10^-6;  %[mH]
H_field = B * 10^-4 / (mu_r*mu0);


%%%%%%
