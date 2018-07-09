for i=1:r
    [audio_framed{i}]=frame_blocking(filtered_audio{i});
    [rows,columns]=size(audio_framed{i});
    for j=1:rows
        ham=hamming(columns);ham=ham';
        audio_framed{i}(j,:)=audio_framed{i}(j,:).*ham;
        audio_framed{i}(j,:)=abs(fft(audio_framed{i}(j,:),nfft));
        power_specs= (1.0/nfft)*(abs(fft(audio_framed{i}(j,:))).^2); 
    end
end
