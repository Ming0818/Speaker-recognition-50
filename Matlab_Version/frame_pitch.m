close all; clear all;
load workspace1_22_6_16.mat
Fs = 11025;

for i = 1:5
    for j = 1:10
        for k = 1:20
            arr(:,:) = audio_sub1(j,k,:);
            arr = arr';
            frames = sp_framed_features(arr, Fs);
        end
    end
end
