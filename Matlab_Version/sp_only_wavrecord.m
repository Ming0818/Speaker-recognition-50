function[audio]=sp_only_wavrecord(NoOfSeconds, Fs)
    audio = wavrecord(Fs*NoOfSeconds, Fs);
end