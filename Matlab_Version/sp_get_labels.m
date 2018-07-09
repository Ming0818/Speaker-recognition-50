function [labels] = sp_get_labels(num_speakers, samples)
    labels = zeros(num_speakers, samples);
    for i = 1:num_speakers
        labels(i,(i-1)*samples+1:(i-1)*samples+samples) = 1;
    end
end