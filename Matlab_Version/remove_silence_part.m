function[processed_audio] = remove_silence_part(y, Fs)
%figure(1):plot(y)
threshold = sp_get_threshold(y, Fs);
%threshold = 0.03;
frame_dur = 0.01;
%figure(1);plot(y);

if length(y)>frame_dur*Fs
    
    frame_len = floor(Fs * frame_dur);

    N = length(y);
    num_frames = floor(N / frame_len);

    processed_audio = zeros(1, N);
    count = 0;

    for k=1 : num_frames
        frame = y( 1, (k-1) * frame_len + 1 : frame_len * k);
        frame=frame-mean(frame);
        max_val = max(frame);
        [~,max_freq]=max(abs(fft(frame)));
        if(max_val > threshold)
            count = count+1;
            processed_audio (1,(count-1) * frame_len + 1 : frame_len * count) = frame;
            %size(processed_audio)
        end
    end
    
    %display(i);
else
    
    
    frame_len = length(y);

    N = length(y);
    num_frames = 1;

    processed_audio = zeros(1, N);
    count = 0;

    for k=1 : num_frames
        frame = y( 1, (k-1) * frame_len + 1 : frame_len * k);
        frame=frame-mean(frame);
        max_val = max(frame);
        [~,max_freq]=max(abs(fft(frame)));
        if(max_val > threshold)
            count = count+1;
            processed_audio (1,(count-1) * frame_len + 1 : frame_len * count) = frame;
            %size(processed_audio)
        end
    end
end
%figure(2):plot(processed_audio)

%figure(2);plot(processed_audio);
%processed_audio(11026:end) = [];
%figure
%plot(processed_audio);
end