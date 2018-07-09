function [ output ] = bpa( feat, labels )
%BPA Summary of this function goes here
%   Detailed explanation goes here
%load audio_features2.mat
%[features2]=sp_smooth_features(features2);
%x=features2'; d=labels;
x=feat';d=labels;
[m,N]=size(x);
net=[6,5];eta=[0.2 0.2];
NoOfLayers=length(net);
%w={rand(net(1),m+1),rand(net(2),net(1)+1),rand(net(3),net(2)+1)};
w={rand(net(1),m+1),rand(net(2),net(1)+1)};
NoOfEpochs=750;
a=sym('x');act_fn={1/(1+exp(-a)),a};

for ep=1:NoOfEpochs
    for iter=1:N
        [dw,error]=sp_bpa(x(:,iter),d(:,iter),act_fn,net,eta,w);
        for i=1:NoOfLayers
            w{i}=w{i}+dw{i};
        end
    end
end

for iter=1:N
        y{1}=[1;x(:,iter)];
        
        for i=1:NoOfLayers
            v{i}=w{i}*y{i};
            if i~=NoOfLayers
                y{i+1}=subs(act_fn{1},'x',v{i});
                y{i+1}=[1;y{i+1}];
            else
                y{i+1}=subs(act_fn{2},'x',v{i});
            end
        end
        output{iter}=y{i+1};
end

end

