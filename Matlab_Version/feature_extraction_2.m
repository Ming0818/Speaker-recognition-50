
clear all;close all;clc;
Fs=11025;
load audio_data.mat

    %%%%%%%%%%%%          Filter-Bank             %%%%%%%%%%%%%%%
    
    
nfft = 256;
mel = zeros(1,42);
    freq = zeros(1,42);
    freq_approx = zeros(1,42);
    initial_hertz = 150;
    num_bins = 40;
    end_hertz = 3200;
    hertz = initial_hertz;
    initial_mel = sp_hz2mel(initial_hertz);
    end_mel = sp_hz2mel(end_hertz);
    var_mel = initial_mel;
    for i1=1:(num_bins+2)
        mel(1,i1) = var_mel;
        freq(1,i1) = sp_mel2hz(var_mel);
        freq_approx(1,i1) = floor((nfft+1)*freq(1,i1)/Fs);
        var_mel = var_mel + end_mel/(num_bins-1);
    end    
    
   filter_bank = zeros(num_bins, nfft);
   for j=1:num_bins
       for i1=int32(freq_approx(j)):int32(freq_approx(j+1))
           filter_bank(j,i1) = (i1 - int32(freq_approx(j)))/(int32(freq_approx(j+1))-int32(freq_approx(j)));
       end
       for i1=int32(freq_approx(j+1)):int32(freq_approx(j+2))
           filter_bank(j,i1) = (int32(freq_approx(j+2))-i1)/(int32(freq_approx(j+2))-int32(freq_approx(j+1)));
       end
   end
   
   %%%%%%%%%%%%%             Normalizing            %%%%%%%%%%%%%
   
%    for i1=1:num_bins
%        filter_bank(i1,:) = filter_bank(i1,:)/sum(filter_bank(i1,:));
%    end
%    plot(filter_bank);
[r,c]=size(audio);
audio_stripped = zeros(r, c);
for i= 1 : r
   %NN= size(audio_stripped)
   audio_stripped(i, :) = remove_silence_part(audio(i, :), Fs);
   audio_without_zeros{i} = remove_trailing_zeros(audio_stripped(i, :));
   
   filtered_audio{i} = butterworth_filter(audio_without_zeros{i},Fs,'bandpass',[150,250,3000,3200],10);
   [peak_amp,peak_freq]=sp_peak_amp_freq(filtered_audio{i},c);
   features(i,1)=peak_freq;
   features(i,2)=peak_amp;
   [pitch_period1, pitch_period2, pitch_period3] = sp_pitch_period(filtered_audio{i},Fs);
   %[pitch_period_1] = pitch_period_freq(audio(i,:),Fs);
   features(i,3:5)=[pitch_period1, pitch_period2, pitch_period3];
   %features(i,4)=pitch_period_1;
   
   %frames=sp_framed_features(audio_stripped(i,:),Fs);
    %%%%%%%%%%%%           Framing signals        %%%%%%%%%%%%%%
    [audio_framed{i}]=frame_blocking(filtered_audio{i});
    
    [rows,columns]=size(audio_framed{i});
    
    %%%%%%%%%%%%          Windowing and FFT       %%%%%%%%%%%%%%%
    for j=1:rows
        ham=hamming(columns);ham=ham';
        audio_framed{i}(j,:)=audio_framed{i}(j,:).*ham;
        audio_framed{i}(j,:)=abs(fft(audio_framed{i}(j,:),nfft));
        power_specs= (1.0/nfft)*(abs(fft(audio_framed{i}(j,:))).^2);
        
    end
   %%%%%%%%%%%%%            Last few steps          %%%%%%%%%%%%%
   
   mfcc_coeffs(i,:) = dct(log(power_specs*filter_bank'));
   
end

% for i=1:r
%     [peak_amp,peak_freq]=sp_peak_amp_freq(audio_stripped(i,:));
%     features(i,1)=peak_freq;
%     features(i,2)=peak_amp;
%     [pitch_period] = sp_pitch_period(audio_stripped(i,:),Fs);
%     %[pitch_period_1] = pitch_period_freq(audio(i,:),Fs);
%     features(i,3)=pitch_period;
%     %features(i,4)=pitch_period_1;
%    
% end