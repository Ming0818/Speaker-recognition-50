function[features]=sp_feature_extraction(filtered_audio,Fs)
display('in feature extraction')
    nfft = 256;
    num_bins = 40;              % for mfcc filter bank
    start_frequency = 150;      % for mfcc filter bank
    end_frequency = 3200;       % for mfcc filter bank
    [~ , c] = size(filtered_audio);
    
    % Filter bank for mfcc  
    filter_bank = sp_get_filter_bank(num_bins, start_frequency, end_frequency, nfft, Fs);

    % features 

    for i = 1:c
        
        [peak_amp,peak_freq]=sp_peak_amp_freq(filtered_audio{i},50);
        features(i,1)=peak_freq;
        %features(i,2)=peak_amp;
        [pitch_period1, pitch_period2, pitch_period3] = sp_pitch_period(filtered_audio{i},Fs);
        %features(i,3:5)=[pitch_period1, pitch_period2, pitch_period3];
        [formant{i},cepstrum{i}] = sp_formant(filtered_audio{i}(1,:), Fs);
        req_formant(i,:)=formant{i};
        req_cepstrum(i,:)=cepstrum{i};
        rcc(i,:)=sp_real_cc(filtered_audio{i}(1,:));
        energy(i,:) = sp_get_energy(filtered_audio{i}(1,:));
        
        
        % mfcc features
        x_n = abs(fft(filtered_audio{i}));
        sum_num=0;
        for var=1:length(x_n)
            sum_num = sum_num + (x_n(1,var)*var);
        end
        centroid(i,1) = Fs/length(filtered_audio{i}(1,:))*sum_num/sum(x_n);
        [audio_framed{i}]=frame_blocking(filtered_audio{i});
        [rows,columns]=size(audio_framed{i});
        
        for j=1:rows
            ham=hamming(columns);ham=ham';
            audio_framed{i}(j,:)=audio_framed{i}(j,:).*ham;
            audio_framed{i}(j,:)=abs(fft(audio_framed{i}(j,:),nfft));
            power_specs= (1.0/nfft)*(abs(fft(audio_framed{i}(j,:))).^2); 
        end
         prod = power_specs*filter_bank';
         prod(prod==0)=eps;
        mfcc_coeffs(i,:) = dct(log(prod));
        mfcc_req_coeffs(i,:)=mfcc_coeffs(i,2:13);
        
        auto_corr_mfcc(i,:) = xcorr(mfcc_coeffs(i,2:13));
        lsf(i,:) = sp_lsf(filtered_audio{i}(1,:), Fs);
        %Hjorth Parameters
        [jactivity(i,1) jmobility(i,1) jcomplexity(i,1)]=emo_hjorth_parameters(filtered_audio{i});
        
        %Wavelet Energy
        [Ea(i,:) Ed(i,:)]=emo_wenergy(filtered_audio{i},'db7',4);
        %zcr avg and standard deviation
        [audio_framed{i}]=frame_blocking(filtered_audio{i}(1, :));
        [rows,columns]=size(audio_framed{i});
     for j=1:rows
         zcr{i}(j,:) = sp_get_zcrs(audio_framed{i}(j,:));
     end
    [avg_zcr(i,:) stdev_zcr(i,:)] = get_avg_stddev(zcr{i}(:,1)); 
   
    end


    features=[lsf jactivity jmobility jcomplexity Ea Ed]; 
    %features = [ features mfcc_req_coeffs req_formant req_cepstrum jactivity jmobility jcomplexity Ea Ed rcc];

end