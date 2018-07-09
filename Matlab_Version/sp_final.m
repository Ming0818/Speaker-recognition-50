    clear; close all; clc; 
    
    load seed1250.mat
    
     display('cast to double');
    % audio = cast(audio,'double');
    Fs=11025;
    smooth_factor=1;
    NoOfSub=5;
    NoOfTrials=250;
    %audio = audio(61:240,:);
    in_sample=0;
    out_sample=1;
    
    net=[28,56,5];eta=[0.35 0.35];
    NoOfLayers=length(net);
    NoOfEpochs=500;
    
    a=sym('x');act_fn={2/(1+exp(-2*a))-1,2/(1+exp(-2*a))-1};
    display('Preprocessing');
    %[filtered_audio]=sp_preprocessing(audio,Fs);
    
    display('Extracting features');
    %[features]=sp_feature_extraction(filtered_audio,Fs);
    load 1250features.mat
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
    %x=[0 0 1 1;0 1 0 1];d=[0 1 1 0];
    
    if in_sample==1
        x=feat';d=labels;
        [m,N]=size(x);
            
        for i=1:NoOfLayers
            if i==1
                w{1,i}=rand(net(1),m+1);
            else
                w{1,i}=rand(net(i),net(i-1)+1);
            end
        end
    
        %Training
        for ep=1:NoOfEpochs
            for iter=1:N
                [dw,error]=sp_bpa(x(:,iter),d(:,iter),act_fn,net,eta,w);
                for i=1:NoOfLayers
                    w{i}=w{i}+dw{i};
                end
            end
            display(ep);
        end
    
        final_weights=w;
    
        %Insample testing
    
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
        
        insample_output=output;
        
        cnt=0;
        for i=1:length(output)        
            [r,c]=size(output{i});
        
            for j=1:r
                if output{i}(j,1)>0.7
                    bin_output(j,i)=1;
                else
                    bin_output(j,i)=0;
                end
            end
        
            if bin_output(:,i)==d(:,i)
                cnt=cnt+1;
            end
        end
    
        %Insample efficiency
        disp('In-sample Efficiency is ');
        insample_efficiency=cnt*100/length(output);
        disp(insample_efficiency);
    
        save seed_trained_weights_rand_trial_set3_rcc.mat net eta feat features labels final_weights
        
        %clear output v w y;
        
    end
    
    
    %Out-sample code
    
    if out_sample==1
        display('training');
        %k-fold cross-validation
    
        for no=1:1
        
            arr=randperm(rows);
            training=arr(1,1:round(0.8*rows));
            testing=setdiff(1:rows,training);
        
            x=feat(training,:)';d=labels(:,training);
            [m,N]=size(x);
            
            
            network=newff(minmax(x),net,{'tansig','tansig','tansig'}); %creates a neural network toolbox object
            y = sim(network, x); %initializes the object
            network.trainParam.epochs=500; %set epochs
            network.trainParam.goal = 0.02;
            network.trainParam.min_grad = 1.00e-6;
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
            out_eff(1,no)=cnt*100/length(output);
            disp(out_eff);
            outsample_efficiency=mean(out_eff);
            
            
%             for i=1:NoOfLayers
%                 if i==1
%                     w{1,i}=rand(net(1),m+1);
%                 else
%                     w{1,i}=rand(net(i),net(i-1)+1);
%                 end
%             end
%     
%             % Out-sample Training
%             for ep=1:NoOfEpochs
%                 for iter=1:N
%                     [dw,error]=sp_bpa(x(:,iter),d(:,iter),act_fn,net,eta,w);
%                     for i=1:NoOfLayers
%                         w{i}=w{i}+dw{i};
%                     end
%                 end
%                 disp('out-sample');
%                 display(ep);
%             end
%         
%             display('testing');
%             x=feat(testing,:)';d=labels(:,testing);
%     
%             for iter=1:length(testing)
%                 y{1}=[1;x(:,iter)];
%         
%                 for i=1:NoOfLayers
%                     v{i}=w{i}*y{i};
%                     if i~=NoOfLayers
%                         y{i+1}=subs(act_fn{1},'x',v{i});
%                         y{i+1}=[1;y{i+1}];
%                     else
%                         y{i+1}=subs(act_fn{2},'x',v{i});
%                     end
%                 end
%                 output{iter}=y{i+1};
%             end
%     
%             cnt=0;
%             for i=1:length(output)        
%                 [r,c]=size(output{i});
%                 max_val = max(output{i}(:,1));
%                 for j=1:r
%                     if output{i}(j,1)==max_val;
%                         bin_output_test(j,i)=1;
%                     else
%                         bin_output_test(j,i)=0;
%                     end
%                 end
%         
%                 if bin_output_test(:,i)==d(:,i)
%                     cnt=cnt+1;
%                 end
%             end
%         
%             disp('Out-sample efficiency');
%             out_eff(1,no)=cnt*100/length(output);
%             disp(out_eff);
%         
%             outsample_efficiency=mean(out_eff);
%         
        end
    
        disp('Average out-sample efficiency');
        disp(outsample_efficiency);
    end
    final_weights = w;
    save weights1250_2.mat net eta feat features network labels final_weights
        
