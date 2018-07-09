function [rcc] = sp_real_cc(arr)
    % real ceptral coefficents are calculated
    %by finding ceptrum of the signal itself 
    % computing fft
    ham = hamming(length(arr));
    arr = arr.*(ham');
    fft_signal = fft(arr);
    % computing log and ifft
    real_cepstrum = abs(ifft(log(fft_signal)));
    rcc = real_cepstrum(1:20);
%     real_cepstrum = abs(real_cepstrum);
%     real_cepstrum = real_cepstrum(1:20);
%     % calculating standard deviation 
%     real_cepstrum = real_cepstrum';
%     mean1 = mean(real_cepstrum);
%     for i = 1 : length(real_cepstrum)
%     real_cepstrum(i,:) = real_cepstrum(i,:)- mean1;
%     real_cepstrum(i,:) = real_cepstrum(i,:)^2;
%     end
%     mean2 = mean(real_cepstrum);
%     std_deviation = sqrt(mean2);
%     std_deviation = abs(std_deviation);
%     std_deviation = std_deviation'
end

    