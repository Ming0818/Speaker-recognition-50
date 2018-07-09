function [ ] = outp( x )
%OUTP Summary of this function goes here
%   Detailed explanation goes here
load seed_toolbox_1.mat
disp(network.IW);
disp(network.LW);
output = sim(network, x);
disp(output);
end

