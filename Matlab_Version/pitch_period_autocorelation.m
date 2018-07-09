function[pitch_period] = pitch_period_autocorelation(y, Fs)

%load trial_6_13_6_16_peas.mat;
%plot(audio(30,:))
%for j=1:50
    corelated_array=xcorr(y(1,:));
    [max_value,max_value_index]=max(corelated_array);
    %plot(q(1,b:b+1000))
    %plot(q)
    %plot(corelated_array(1,max_value_index:length(corelated_array)));
    min=max_value;
    for i=max_value_index:length(corelated_array)
        if (corelated_array(i) < min)
            min = corelated_array(i);
        end
        if min < corelated_array(i)
             first_minima_index= i;
             first_minima_value = corelated_array(i);
             break;
        end
    end

[second_peak_value,second_peak_index] = max(corelated_array(1,first_minima_index:end));

 pitch_period = second_peak_index / Fs;
 end
%plot(abs(q(1,b:b+1000)))