function[filtered_arr,order]=butterworth_filter(arr,Fs,type,cutoff,order)


Rp=1;    %Passband Ripple
Rs=60;      %Stopband Ripple

if length(cutoff)==4
    Ws1=2*cutoff(1)/Fs;
    Wp1=2*cutoff(2)/Fs;
    Wp2=2*cutoff(3)/Fs;
    Ws2=2*cutoff(4)/Fs;
    Wn=[Wp1 Wp2];
elseif length(cutoff)==2
    Wp1=2*cutoff(1)/Fs;
    Ws1=2*cutoff(2)/Fs;
    Wn=Wp1;
elseif length(cutoff)==1
    Wp1=2*cutoff/Fs;
    Wn=Wp1;
else
    display('ERROR: Give proper cut-off values ');
end
    
if nargin<5
    if length(cutoff)==2
        [order,Wn]=buttord(Wp1,Ws1,Rp,Rs);
    elseif length(cutoff)==4
        [order,Wn]=buttord([Wp1 Wp2],[Ws1 Ws2],Rp,Rs);
    else
        display('ERROR: Give proper cut-off values ');
        display('ERROR: Both passband and stopband needs to be given, inorder to calculate the order automatically ');
    end
end

if strcmp(type,'lowpass')
    [B,A]=butter(order,Wn,'low');    
elseif strcmp(type,'highpass')
    [B,A]=butter(order,Wn,'high');
elseif strcmp(type,'bandpass')
    [B,A]=butter(order,Wn,'bandpass');
elseif strcmp(type,'bandstop')
    [B,A]=butter(order,Wn,'stop');
else
    Display('ERROR: Type of butterworth filter not specified correctly ');
end

filtered_arr=filter(B,A,arr);

% N=10;Wn=(100/(0.5*Fs));
% [B,A]=butter(N,Wn,'low');
% x2=filter(B,A,x);

end