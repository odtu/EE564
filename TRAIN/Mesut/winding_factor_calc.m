function [kd,kp,kw] = winding_factor_calc(alfa,q,lambda)
    n = 1:2:31;
    kd = sin(n*q*alfa/2)./(q*sin(n*alfa/2));
    kp = sin(n*lambda/2);
    kw = kd.*kp;
end