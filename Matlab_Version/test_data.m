clear; clc;
Fs=11025;NoOfSeconds=2;
display('Subject1 get ready');
pause(5);
for i=1:2
    pause(2);
    display(['speak trial ',num2str(i)]);
    audio1=wavrecord(NoOfSeconds*Fs,Fs);
    display('------done------');
    audio_sub1(i,:)=audio1';
end
load trial_5_13_6_16_research.mat
load research_features_all.mat
load research_features_stat.mat
features = features(1:50,:);
Fs = 11025;
nfft = 256;
num_bins = 40; % for mfcc filter bank
start_frequency = 150; % for mfcc filter bank
end_frequency = 3200; % for mfcc filter bank
num_speakers = 3;
sample_per_person = 10;
%%%%%%%% Preprocessing %%%%%%%%%
test_audio = audio_sub1(1:2,:);
%test_audio = audio_sub1(1:2,:);
[r , c] = size(test_audio);

for rows = 1:r
     audio_stripped(rows,:) = remove_silence_part(test_audio(rows, :), Fs);
    audio_without_zeros{rows} = remove_trailing_zeros(audio_stripped(rows, :));
    
    clear audio_stripped;
    
     filtered_audio{rows} = butterworth_filter(audio_without_zeros{rows},Fs,'bandpass',[150,250,3000,3200],10);
    
    clear audio_without_zeros;
    
end

%%%%%% Feature Extraction %%%%%%%%%%

    %%%%%%% Filter bank for mfcc  %%%%%%%%
filter_bank = sp_get_filter_bank(num_bins, start_frequency, end_frequency, nfft, Fs);

%%% features %%%
for i = 1:r
    [peak_amp,peak_freq]=sp_peak_amp_freq(filtered_audio{i},c);
    features_test(i,1)=peak_freq;
    features_test(i,2)=peak_amp;
    [pitch_period1, pitch_period2, pitch_period3] = sp_pitch_period(filtered_audio{i},Fs);
    features_test(i,3:5)=[pitch_period1, pitch_period2, pitch_period3];
    [formant{i},cepstrum{i}] = sp_formant(filtered_audio{i}(1,:), Fs);
end

%%% mfcc features

%mfcc(filtered_audio, filter_bank)

for i=1:r
    [audio_framed{i}]=frame_blocking(filtered_audio{i});
    [rows,columns]=size(audio_framed{i});
    for j=1:rows
        ham=hamming(columns);ham=ham';
        audio_framed{i}(j,:)=audio_framed{i}(j,:).*ham;
        audio_framed{i}(j,:)=abs(fft(audio_framed{i}(j,:),nfft));
        power_specs= (1.0/nfft)*(abs(fft(audio_framed{i}(j,:))).^2); 
    end
    
mfcc_coeffs(i,:) = dct(log(power_specs*filter_bank'));

end

features_test(:,3) = features_test(:,4);
for i=6:17
    features_test(:,i) = mfcc_coeffs(:,i-4);
end
for i=18:19
    for j = 1:2
        features_test(j,i) = formant{j}(i-17);
    end
end

for i = 20:33
    for j = 1:2
        features_test(j,i) = cepstrum{j}(i-19);
    end
end

features = [features; features_test];

%save matlab_features_stat.mat features
%features = features(:,1:17);
feat = sp_smoothen_features(features);
x = feat(51:52,:);
x = x';
[m, N] = size(net);
NoOfLayers = length(net);
a=sym('x');act_fn={1/(1+exp(-a)),a};

for iter=1:2
        y{1}=[1;x(:,iter)];
        
        for i=1:NoOfLayers
            v{i}=w{i}*y{i};
            if i~=NoOfLayers
                y{i+1}=subs(act_fn{1},'x',v{i});
                y{i+1}=[1;y{i+1}];
            else
                y{i+1}=subs(act_fn{2},'x',v{i});
            end
        end
        output{iter}=y{i+1};
end
