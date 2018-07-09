clear;
close all;
clc;
Fs=11025;NoOfSeconds=4;

words{1}='SIP ... ZIP';
words{2}='PAT ... BAT';
words{3}='PIN ... BIN';
words{4}='TWO ... DO';
words{5}='TEN ... DEN';
words{6}='FINE ... VINE';
words{7}='COME ... GUM';
words{8}='COAT ... GOAT';
words{9}='THANK ... THESE';
words{10}='CHIN ... JIN';

pause(5);
display('Subject1 get ready');
pause(5);
for j=1:10
    for i=1:20
        pause(2);
        display(['speak word1 ',num2str(i),words{j}]);
        audio1=wavrecord(NoOfSeconds*Fs,Fs);
        display('------done------');
        audio_sub1(j,i,:)=audio1';
    end
end

display('Subject2 get ready');
pause(5);
for j=1:10
    for i=1:20
        pause(2);
        display(['speak word ',num2str(i),words{j}]);
        audio1=wavrecord(NoOfSeconds*Fs,Fs);
        display('------done------');
        audio_sub2(j,i,:)=audio1';
    end
end

display('Subject3 get ready');
pause(5);
for j=1:10
    for i=1:20
        pause(2);
        display(['speak word ',num2str(i),words{j}]);
        audio1=wavrecord(NoOfSeconds*Fs,Fs);
        display('------done------');
        audio_sub3(j,i,:)=audio1';
    end
end

display('Subject4 get ready');
pause(5);
for j=1:10
    for i=1:20
        pause(2);
        display(['speak word ',num2str(i),words{j}]);
        audio1=wavrecord(NoOfSeconds*Fs,Fs);
        display('------done------');
        audio_sub4(j,i,:)=audio1';
    end
end


display('Subject5 get ready');
pause(5);
for j=1:10
    for i=1:20
        pause(2);
        display(['speak word ',num2str(i),words{j}]);
        audio1=wavrecord(NoOfSeconds*Fs,Fs);
        display('------done------');
        audio_sub5(j,i,:)=audio1';
    end
end






% end
% figure(1);plot(audio1);
% figure(2);
% fft_audio1=fft(audio1(1:length(audio1)));
% plot(Fs*(1:length(audio1)/2)/length(audio1),abs(fft_audio1(1:length(audio
% 1)/2)));