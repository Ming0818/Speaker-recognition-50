clear all;
close all;
clc;

Fs=800;f=0.02;
t=2*pi*(1/Fs:1/Fs:1);
y=sin(f*t);
figure(1);plot(y);
y2=abs(fft(y));
figure(2);plot(y2);
figure(3);plot(Fs*(1:length(y2)/2)/length(y2),y2(1:length(y2)/2));
Rp=60;Wp=70;Ws=90;Rs=100;
Rp=Rp/Rs;Wp=Wp/Rs;Ws=Ws/Rs;Rs=1;
[N,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(N,Wn);
filtered_y=filter(b,a,y);
fft_filt_y=abs(fft(filtered_y));
figure(4);plot(Fs*(1:length(filtered_y)/2)/length(filtered_y),fft_filt_y(1:length(filtered_y)/2));