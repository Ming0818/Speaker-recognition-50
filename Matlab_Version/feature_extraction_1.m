clear all;close all;clc;

load trial_6_13_6_16_peas.mat

[r,c]=size(audio);

for i=1:r
    [peak_amp,peak_freq]=sp_peak_amp_freq(audio(i,:));
    features(i,1)=peak_freq;
    features(i,2)=peak_amp;
end