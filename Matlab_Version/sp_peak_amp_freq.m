function[peak_amp,peak_freq]=sp_peak_amp_freq(arr,len)
        
    [peak_amp,peak_freq]=max(abs(fft(arr)));
    peak_freq = peak_freq*(len/length(arr));
%    plot(fft(arr));
end