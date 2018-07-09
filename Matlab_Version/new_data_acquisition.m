clear;
close all;
clc;
Fs=11025;NoOfSeconds=2;

words{1}='PROCEED';
words{2}='';
pause(5);
display('Subject1 get ready');
pause(5);

for j=1:2
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
for j=1:2
    for i=1:20
        pause(2);
        display(['speak word ',num2str(i),words{j}]);
        audio1=wavrecord(NoOfSeconds*Fs,Fs);
        display('------done------');
        audio_sub2(j,i,:)=audio1';
    end
end
