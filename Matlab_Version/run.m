clear all; close all;
clc;

load trial_5_13_6_16_research.mat

%%%%%%%%% constants %%%%%%%%%%%%
Fs = 11025;
nfft = 256;
num_bins = 40; % for mfcc filter bank
start_frequency = 150; % for mfcc filter bank
end_frequency = 3200; % for mfcc filter bank
num_speakers = 5;
sample_per_person = 10;
%%%%%%%% Preprocessing %%%%%%%%%

[r , c] = size(audio);

for rows = 1:r
     audio_stripped(rows,:) = remove_silence_part(audio(rows, :), Fs);
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
    features(i,1)=peak_freq;
    features(i,2)=peak_amp;
    [pitch_period1, pitch_period2, pitch_period3] = sp_pitch_period(filtered_audio{i},Fs);
    features(i,3:5)=[pitch_period1, pitch_period2, pitch_period3];
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

for i=6:17
    features(:,i) = mfcc_coeffs(:,i-4);
end
for i=18:19
    for j = 1:2
        features(j,i) = formant{j}(i-17);
    end
end

for i = 20:33
    for j = 1:2
        features(j,i) = cepstrum{j}(i-19);
    end
end

feat = sp_smoothen_features(features);

%%%%%%%% Classification %%%%%%%%%%%

for testcase = 1: 1
    feat_bpa = feat;
    
    perm = randperm(num_speakers*sample_per_person);
    
    train_length = floor(80*num_speakers*sample_per_person/100);
    for i = 1:num_speakers*sample_per_person
        speaker = ceil(perm(i)/10);
        if i <= train_length
            train_input(i,:) = feat_bpa(perm(i),:);
            for j = 1: num_speakers
                if j == speaker
                    train_labels(j,i) = 1;
                else
                    train_labels(j,i) = 0;
                end
            end
        else
            test_input(i-train_length,:) = feat_bpa(perm(i),:);
            for j = 1: num_speakers
                if j == speaker
                    test_labels(j,i-train_length) = 1;
                else
                    test_labels(j,i-train_length) = 0;
                end
            end
        end
    end
    
    
    %output = bpa(feat_without_mfcc, labels);
    
    x=train_input';d=train_labels;
    [m,N]=size(x);
    net=[10, 5];eta=[0.2 0.2];
    NoOfLayers=length(net);
    
    w={rand(net(1),m+1),rand(net(2),net(1)+1)};
    NoOfEpochs=1000;
    a=sym('x');act_fn={1/(1+exp(-a)),a};
    
    for ep=1:NoOfEpochs
        for iter=1:N
            [dw,error]=sp_bpa(x(:,iter),d(:,iter),act_fn,net,eta,w);
            for i=1:NoOfLayers
                w{i}=w{i}+dw{i};
            end
        end
        display(ep);
    end
    
    for iter=1:N
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
    
    
    
    output = round_up(output);
    
    for i=1:length(output)
        for j = 1:length(output{i})
            if output{i}(1,j) == 1
                speaker_train(1,i) = j;
            end
        end
    end
    
    [width, lengt] = size(train_labels);
    for i = 1: lengt
        for j = 1: width
            if train_labels(j,i) == 1
                correct_speaker_train(1,i) = j;
            end
        end
    end
    
    results = [speaker_train' correct_speaker_train'];
    count = 0;
    for i =1:train_length
        if results(i,1) - results(i,2) == 0
            count = count + 1;
        end
    end
    
    in_sample(1) = count*100/train_length;
    
    test_input = test_input';
    for iter=1:num_speakers*sample_per_person - train_length
        y{1}=[1;test_input(:,iter)];
        
        for i=1:NoOfLayers
            v{i}=w{i}*y{i};
            if i~=NoOfLayers
                y{i+1}=subs(act_fn{1},'x',v{i});
                y{i+1}=[1;y{i+1}];
            else
                y{i+1}=subs(act_fn{2},'x',v{i});
            end
        end
        test_output{iter}=y{i+1};
    end
    
    test_output = round_up(test_output);
    
    for i=1:length(test_output)
        for j = 1:length(test_output{i})
            if test_output{i}(1,j) == 1
                speaker_test(1,i) = j;
            end
        end
    end
    
    [width, lengt] = size(test_labels);
    for i = 1: lengt
        for j = 1: width
            if test_labels(j,i) == 1
                correct_speaker_test(1,i) = j;
            end
        end
    end
    
    result_test = [speaker_test' correct_speaker_test'];
    
    count = 0;
    for i =1:num_speakers*sample_per_person - train_length
        if result_test(i,1) - result_test(i,2) == 0
            count = count + 1;
        end
    end
    
    out_sample(1) = count*(100/(50-train_length));
%     
%         clear train_input; clear train_labels;
%         clear test_input; clear test_labels;
 end
% 
% inp1 = feat(21:40,:);
% inp2 = feat(101:120,:);
% inp3 = feat(161:180,:);
% inp4 = feat(221:240,:);
% inp5 = feat(281:300,:);
% inp6 = feat(61:80,:);
% inp7 = feat(41:60,:);
% inp8 = feat(121:140,:);
% inp9 = feat(301:320,:);
% inp10 = feat(241:260,:);
% 
% input = [inp1; inp2; inp3; inp4; inp5; inp6; inp7; inp8; inp9; inp10];
% labels = sp_get_labels(10,20);
