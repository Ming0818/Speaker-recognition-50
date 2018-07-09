function[pitch_period, pitch_freq,max1,sample_no,autocor]=pitch_period_freq(y, Fs)
%[y,Fs,bits]=wavread('/media/A03036C33036A068/scilab/30msec_voiced.wav');//input: speech segment
%max_value=max(abs(y));
% y=y/max_value;
%t=(1/Fs:1/Fs:(length(y)/Fs))*1000;
%subplot(2,1,1);
%plot(t,y);
sum1=0;autocorrelation=0;
   for l=0:(length(y)-1)
    sum1=0;
    for u=1:(length(y)-l)
      s=y(u)*y(u+l);
      sum1=sum1+s;
    end
    autocor(l+1)=sum1;
  end
%kk=(1/Fs:1/Fs:(length(autocor)/Fs))*1000;
%subplot(2,1,2);
%plot(kk,autocor);
auto=autocor(21:160);
  max1=0;
  for uu=1:140
    if(auto(uu)>max1)
      max1=auto(uu);
      sample_no=uu;
    end 
  end
  pitch_period=(20+sample_no)*(1/Fs)
  pitch_freq=1/pitch_period
end