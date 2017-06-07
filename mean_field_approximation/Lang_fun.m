%% Langevin function (eqn.4.21 in Coey's book)
% output: 
% Bri_val, brillium function
% Bri_prime, derivative of brillium function
function [Bri_val,Bri_prime]=Lang_fun(x)
Bri_val=coth(x)-1/x;
if (0)    %get_analy_briprime
syms x
    Bri=coth(x)-1/x;
    Bri_prime=diff(Bri,x)
end
Bri_prime=1/x^2 - coth(x)^2 + 1;
end
    
    
    