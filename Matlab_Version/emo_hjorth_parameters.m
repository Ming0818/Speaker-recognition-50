function[jactivity jmobility jcomplexity]=emo_hjorth_parameters(arr)

y=arr;
x=(1:length(y));
jactivity=var(y(1,:));
dy_dx=diff(y(1,:))./diff(x(1,:));
dy_dx=[zeros(1,1) dy_dx];
jmobility=sqrt(var(dy_dx(1,:))/jactivity);

dy_dx2=diff(dy_dx(1,:))./diff(x(1,:));
dy_dx2=[zeros(1,1) dy_dx2];
jmobility2=sqrt(var(dy_dx2(1,:))/var(dy_dx(1,:)));
jcomplexity=jmobility2/jmobility;

end