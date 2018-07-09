function [ filter_bank ] = sp_get_filter_bank( num_bins, initial_hertz, end_hertz, nfft, Fs )
%SP_GET_FILTER_BANK Summary of this function goes here
%   Detailed explanation goes here
mel = zeros(1,num_bins+2);
freq = zeros(1,num_bins+2);
freq_approx = zeros(1,num_bins+2);

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


end

