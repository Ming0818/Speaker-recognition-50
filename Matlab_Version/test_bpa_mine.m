clear;clc;

x=[0 0 1 1;0 1 0 1];d=[0 1 1 0];
%load audio_features2.mat
%[features2]=sp_smooth_features(features2);
%x=features2'; d=labels;
load data_for_train.mat
% feat=feat(201:600,:);
x=input';d=labels;
[m,N]=size(x);
net=[15,20,10];eta=[0.25 0.25 0.25];
NoOfLayers=length(net);
%w={rand(net(1),m+1),rand(net(2),net(1)+1),rand(net(3),net(2)+1)};
w={rand(net(1),m+1),rand(net(2),net(1)+1),rand(net(3),net(2)+1)};
NoOfEpochs=500;
a=sym('x');act_fn={1/(1+exp(-a)),a};

for ep=1:NoOfEpochs
    for iter=1:N
        [dw,error]=sp_bpa(x(:,iter),d(:,iter),act_fn,net,eta,w);
        for i=1:NoOfLayers
            w{i}=w{i}+dw{i};
        end
    end
    display(ep);
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

res_output = round_up(output);
for i=1:length(res_output)
        for j = 1:length(res_output{i})
            if res_output{i}(1,j) == 1
                speaker_test(1,i) = j;
            end
        end
end
    [width, lengt] = size(labels);
    for i = 1: lengt
        for j = 1: width
            if labels(j,i) == 1
                correct_speaker_test(1,i) = j;
            end
        end
    end
    result_test = [speaker_test' correct_speaker_test'];
    count = 0;
    for i =1:200
        if result_test(i,1) - result_test(i,2) == 0
            count = count + 1;
        end
    end
    