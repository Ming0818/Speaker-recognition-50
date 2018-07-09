function [ mel ] = sp_hz2mel( hz )
%SP_HZ2MEL Summary of this function goes here
%   Detailed explanation goes here
    mel = 2595*log10((1+hz/700));
end

