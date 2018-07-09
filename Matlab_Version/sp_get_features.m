function [ features ] = sp_get_features( i, filtered_audio, c )
%SP_GET_FEATURES Summary of this function goes here
%   Detailed explanation goes here
    [peak_amp,peak_freq]=sp_peak_amp_freq(filtered_audio{i},c);
    features(i,1)=peak_freq;
    features(i,2)=peak_amp;
    [pitch_period1, pitch_period2, pitch_period3] = sp_pitch_period(filtered_audio{i},Fs);
    features(i,3:5)=[pitch_period1, pitch_period2, pitch_period3];
end

