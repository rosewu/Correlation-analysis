function [mu,sigma]=fCalP(mean)
% calculate mu and sigma for lognormal distribution from mean and std
m = mean;
std = m*0.2;
v = std^2;

mu = log(m^2/((v + m^2)^(1/2)));
sigma = (log(v/m^2+1))^(1/2);
end
