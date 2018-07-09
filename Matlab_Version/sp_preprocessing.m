function[filtered_audio]=sp_preprocessing(audio,Fs)
    
    [r , c] = size(audio);

    for rows = 1:r
        audio_stripped(rows,:) = remove_silence_part(audio(rows, :), Fs);
        audio_without_zeros{rows} = remove_trailing_zeros(audio_stripped(rows, :));
    
    %    clear audio_stripped;
    
        filtered_audio{rows} = butterworth_filter(audio_without_zeros{rows},Fs,'bandpass',[150,250,3000,3200],10);
    
        clear audio_without_zeros;
    
    end

end
