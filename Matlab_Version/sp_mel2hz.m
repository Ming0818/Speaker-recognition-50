function [ hz ] = sp_mel2hz( mel )
%SP_MEL2HZ Summary of this function goes here
%   Detailed explanation goes here
    hz = 10 ^ (mel/2595);
    hz = (hz -1)*700;

end

