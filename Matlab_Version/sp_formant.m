function [ formants ,cepstrum] = sp_formant(arr,Fs)
%Pre-emphasis is a signal processing method which increases the 
%amplitude of high frequency bands and decrease the amplitudes of lower bands.
%use the general rule that the order is two times the expected number of
%formants plus 2.
    x = arr.*(hamming(length(arr)))';  % applying hamming window
    preemph = [1 0.63];  % pre-emphasis filter
    x1 = filter(1,preemph,x); % applying the filter using filter fuction
    n_coeff = 2 + Fs / 1000;
    %A = lpc(x1,n_coeff); % finding lpc coefficients
    [A,g] = lpc(x1,n_coeff);
    ARPowerSpectrum = g ./ abs(fft(A,1024)).^2;
    cepstrum =  ifft(log(ARPowerSpectrum),1024);
    cepstrum = cepstrum(1:14);
    [h,f]=freqz(1,A,512,Fs);
    %plot(f,20*log10(abs(h)+eps));
    rts = roots(A); % finding the roots of the lpc polynomial
    rts = rts(imag(rts)>=0); % the roots were conjugate pairs taking only one of them
    angz = atan2(imag(rts),real(rts)); % finding the angular frequency
    [frqs,indices] = sort(angz.*(Fs/(2*pi))); % angular frequency (rad/sample)to hertz
    bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices)));% bandwith of formnat formula taken from literature
    nn = 1;
    for kk = 1:length(frqs)
        if (frqs(kk) > 90 && bw(kk) <400)
            formants(nn) = frqs(kk);
            nn = nn+1;
        end
    end 
    formants= formants(1:2);
end
    