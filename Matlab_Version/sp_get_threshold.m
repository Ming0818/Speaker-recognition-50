function [ threshold ] = sp_get_threshold(arr, Fs )
    noise_length = 0.1*Fs;
    scaling_factor = 0.7;
    max_val = max(abs(arr(1,20:round(noise_length))));
    threshold = scaling_factor*max_val;
end

