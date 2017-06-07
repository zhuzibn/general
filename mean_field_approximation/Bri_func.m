%% brillium function (eqn.4.17 in Coey's book),reduce to Langevin function in the limit J->infinite
% output: 
% Bri_val, brillium function
% Bri_prime, derivative of brillium function
function [Bri_val,Bri_prime]=Bri_func(x,J)
%Bri_val=coth(x)-1/x;
Bri_val=(2*J+1)/(2*J)*coth((2*J+1)/(2*J)*x)-coth(x/(2*J))/(2*J);
if (0)    %get_analy_briprime
syms x J
    Bri=(2*J+1)/(2*J)*coth((2*J+1)/(2*J)*x)-coth(x/(2*J))/(2*J);
    Bri_prime=diff(Bri,x)
end
Bri_prime=(coth(x/(2*J))^2 - 1)/(4*J^2) - ((2*J + 1)^2*(coth((x*(2*J + 1))/(2*J))^2 - 1))/(4*J^2);
end
    
    
    