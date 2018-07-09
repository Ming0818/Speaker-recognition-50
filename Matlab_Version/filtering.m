clear all;
close all;
clc;
%load trial1.mat
%y=audio(1,:);
t=-pi:0.0001:pi;Fs=50;
y=sin(Fs*t);
Rp=60;Wp=70;Ws=90;Rs=100;
Rp=Rp/Rs;Wp=Wp/Rs;Ws=Ws/Rs;Rs=1;
[N,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(N,Wn);
filtered_y=filter(b,a,y);
figure(1);
y3=abs(fft(y));
plot(Fs*(1:length(y3)/2)/length(y3),y3(1:length(y3)/2));
figure(2);
y2=abs(fft(filtered_y));
plot(Fs*(1:length(y2)/2)/length(y2),y2(1:length(y2)/2));