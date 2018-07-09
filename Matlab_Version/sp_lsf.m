function [lsfs] = sp_lsf(arr,Fs)
    x = arr.*(hamming(length(arr)))'; % hamming window
    preemph = [1 0.97];  % pre-emphasis filter
    x1 = filter(1,preemph,x);
    n_coeff = 2 + Fs / 1000; % number of coefficients for lpc
    A = lpc(x1,n_coeff); % LPC coefficients
    lsfs = poly2lsf(A); % linear spectral frequencies range is within (0,pi) 
    