function [frames ] = sp_framed_features( arr, Fs ) 
    frame_dur = 0.03;
    len = length(arr);
    frame_len = Fs * frame_dur;
    num_frames = floor(len / frame_len);
    start_index = 1;
    frame_width = floor(frame_len*Fs);
    end_index = start_index + frame_width;
    frames = zeros(num_frames+1, round(frame_len*Fs));
    for i = 1:num_frames+1
        if start_index < len
            break
        elseif end_index < len
            frames(i,:) = arr(1,start_index:end_index);
            start_index = end_index+1;
            end_index = start_index + frame_width;
        
        else
            frames(i,:) = arr(1,start_index:len);
        end
    end
end

