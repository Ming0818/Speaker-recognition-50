clear all;close all;clc;
Fs=11025;
load trial_6_13_6_16_peas.mat

[r,c]=size(audio);
features = zeros(50,6);
for i=1:r
    [peak_amp,peak_freq]=sp_peak_amp_freq(audio(i,:));
    features(i,1)=peak_freq;
    features(i,2)=peak_amp;
    [pitch_period, pitch_freq] = pitch_period_freq(audio(i,:),Fs);
    features(i,3)=pitch_period;
    features(i,4)=pitch_freq;
    %[pitch_period, pitch_freq] = cep_pitch(audio(i,:),Fs);
    %features(i,5)=pitch_period;
    %features(i,6)=pitch_freq;
end