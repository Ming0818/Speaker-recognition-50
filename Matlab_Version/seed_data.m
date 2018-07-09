clc; clear all;

Fs = 11025;
for i=1:20
    baseline = wavrecord(1*Fs, Fs);
    display('speak word ');
    audio1=wavrecord(2*Fs,Fs);
    display('------done------');
    audio(i,:)=[baseline' audio1'];
end