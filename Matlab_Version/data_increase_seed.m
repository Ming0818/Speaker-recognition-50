clc; clear all;
%seed
Fs = 11025;
for i=1:250
    %ch = input('press Enter when you are ready speaker1 ');
    display('wait');
    baseline = wavrecord(1*Fs, Fs);
    pause(1);
    disp(i);
    display('speak word ');
    audio1=wavrecord(2*Fs,Fs);
    display('------done------');
    audio_sub1(i,:)=[baseline' audio1'];
end
% for i=1:20
%     %ch = input('press Enter when you are ready speaker2 ');
%     baseline = wavrecord(1*Fs, Fs);
%     pause(1);
%     display('speak word ');
%     audio1=wavrecord(2*Fs,Fs);
%     display('------done------');
%     audio_sub4(i,:)=[baseline' audio1'];
% end
% for i=1:20
%     %ch = input('press Enter when you are ready speaker3 ');
%     baseline = wavrecord(1*Fs, Fs);
%     pause(1);
%     display('speak word ');
%     audio1=wavrecord(2*Fs,Fs);
%     display('------done------');
%     audio_sub3(i,:)=[baseline' audio1'];
% end
% for i=1:20
%     %ch = input('press Enter when you are ready speaker4 ');
%     baseline = wavrecord(1*Fs, Fs);
%     pause(1);
%     display('speak word ');
%     audio1=wavrecord(2*Fs,Fs);
%     display('------done------');
%     audio_sub2(i,:)=[baseline' audio1'];
% 
% end
% 
% audio = [audio_sub1; audio_sub2; audio_sub3; audio_sub4];
% labels = sp_get_labels(4, 20);