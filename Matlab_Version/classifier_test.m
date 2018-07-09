clear; close all; clc; 
    
    load latest_seed_300.mat
    
     display('cast to double');
    % audio = cast(audio,'double');
    Fs=11025;
    smooth_factor=1;
    NoOfSub=3;
    NoOfTrials=60;
    audio = audio(61:240,:);
    in_sample=0;
    out_sample=1;
    
    net=[15, 3];eta=[0.25 0.25];
    NoOfLayers=length(net);
    NoOfEpochs=400;
    
    a=sym('x');act_fn={1/(1+exp(-a)),a};
    display('Preprocessing');
    [filtered_audio]=sp_preprocessing(audio,Fs);
    
    display('Extracting features');
    [features]=sp_feature_extraction(filtered_audio,Fs);
    
    %[features,eig_val]=emo_pca(features,20);
    
    feat=sp_smoothen_features( features,smooth_factor );
    
    %feat=feat(:,1:33);
        
    [rows,col]=size(feat);
    display('labels');
    labels=zeros(NoOfSub,NoOfTrials);
    for i=1:rows
        if mod(i,NoOfTrials)==0
            labels(floor(i/NoOfTrials),i)=1;
        else
            labels(floor(i/NoOfTrials)+1,i)=1;
        end
    end
    randarr=randperm(rows);
    feat=feat(randarr,:);
    labels=labels(:,randarr);
    display('Subject get ready');
pause(5);
clear audio;
% for i=1:10
%     pause(2);
%     audio_baseline=wavrecord(1*Fs,Fs);
%     display(['speak trial ',num2str(i)]);
%     audio1=wavrecord(2*Fs,Fs);
%     display('------done------');
%     audio(i,:)=[audio_baseline' audio1'];
% end
% save real_audio.mat audio
load real_audio.mat
[r,c]=size(features);
[filtered_audio]=sp_preprocessing(audio,Fs);
    
[features_test]=sp_feature_extraction(filtered_audio,Fs);

%[features_test,eig_val]=emo_pca(features_test,20);

features=[features;features_test];

feat1=sp_smoothen_features( features,smooth_factor );

feat_test=feat1(r+1:end,:);
for loop=1:100
if out_sample==1
        display('training');
        %k-fold cross-validation
    
        for no=1:5
            if no > 1
                clear network
            end
            arr=randperm(rows);
            training=arr(1,1:round(0.8*rows));
            testing=setdiff(1:rows,training);
        
            x=feat(training,:)';d=labels(:,training);
            [m,N]=size(x);
            
            
            network=newff(minmax(x),net); %creates a neural network toolbox object
            y = sim(network, x); %initializes the object
            network.trainParam.epochs=400; %set epochs
            network.trainParam.goal = 0.025;
            network.TrainParam.min_grad = 1.00e-6;
            network=train(network, x, d); %train the network with x as input and d as labels
            y = sim(network, x); %insample testing output
            x1 = feat(testing,:)'; d = labels(:,testing);
            output = sim(network, x1); %outsample testing output
            close all;
            cnt=0;
            for i=1:length(output)        
                max_val = max(output(:,i));
                for j=1:NoOfSub
                    if output(j,i)==max_val;
                        bin_output_test(j,i)=1;
                    else
                        bin_output_test(j,i)=0;
                    end
                end
        
                if bin_output_test(:,i)==d(:,i)
                    cnt=cnt+1;
                end
            end
            w{1} = [network.b{1} network.IW{1}];
            w{2} = [network.b{2} network.LW{2}];
            disp('Out-sample efficiency');
            out_eff=cnt*100/length(output);
            disp(out_eff);
            if out_eff > 80
                disp('breaking');
                break
            end
            
            eff(1,i)=(out_eff);
            %outsample_efficiency=mean(out_eff);
            
            %outsample_efficiency=mean(out_eff);
        
        end
    
        disp('Average out-sample efficiency');
        %disp(outsample_efficiency);
        final_weights = w;
end
x=feat_test';
%outp(x);
output = sim(network, x);
    
    test_output=output;
    
    [r, c] = size(output);
    sp_correct_count = 0;
    for i = 1:c
        k=1;
        speaker_op{k,i}='Speaker No';
        k=k+1;
        for j = 1:r
            if(output(j,i)) >= 0.5
                speaker_op{k,i}=j; k=k+1;
                speaker_op{k,i}=100-abs(1-(output(j,i)))*100;
                k=k+1;
            end
        end
        
        [max_val, index] = max(output(:,i));
        output(index,i) = 1;
        output(setdiff(1:r,index),i) = 0;
                if index == 2
            sp_correct_count = sp_correct_count +1;
        end
    end
    class_test(1,loop)=sp_correct_count;
    net(1,1) = net(1,1)+1;
    disp([loop sp_correct_count]);
end 
    
    save network_param.mat class_test
    