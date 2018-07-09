clear;close all;clc;

load weights1250_2.mat

%w=final_weights;

Fs=11025;
smooth_factor=1;
NoOfSeconds=2;
NoOfTrials=5;
NoOfLayers=length(net);
[r,c]=size(features);
a=sym('x');act_fn={2/(1+exp(-2*a))-1,2/(1+exp(-2*a))-1};

display('Subject get ready');
pause(5);
for i=1:NoOfTrials
    pause(2);
    display(['speak trial ',num2str(i)]);
    audio1=wavrecord(NoOfSeconds*Fs,Fs);
    display('------done------');
    audio(i,:)=audio1';
end


[filtered_audio]=sp_preprocessing(audio,Fs);
    
[features_test]=sp_feature_extraction(filtered_audio,Fs);

%[features_test,eig_val]=emo_pca(features_test,20);

features=[features;features_test];

feat=sp_smoothen_features( features,smooth_factor );

feat_test=feat(r+1:end,:);

[rows,col]=size(feat_test);

x=feat_test';
%outp(x);
output = sim(network, x);
%     for iter=1:rows
%             y{1}=[1;x(:,iter)];
%         
%             for i=1:NoOfLayers
%                 v{i}=w{i}*y{i};
%                 if i~=NoOfLayers
%                     y{i+1}=subs(act_fn{1},'x',v{i});
%                     y{i+1}=[1;y{i+1}];
%                 else
%                     y{i+1}=subs(act_fn{2},'x',v{i});
%                 end
%             end
%             output{iter}=y{i+1};
%     end
    
    test_output=output;
    
    [r, c] = size(output);
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
        
    end
%     for i=1:length(output)
%         k=1;
%         speaker_op{k,i}='Speaker No';
%         k=k+1;
%         [r1,c1]=size(output{i});
%         
%         for j=1:r1
%             
%             if output{i}(j,1)>=0.5
%                 
%                 speaker_op{k,i}=j; k=k+1;
%                 speaker_op{k,i}=100-abs(1-output{i}(j,1))*100;
%                 k=k+1;
%             end
%         end
%         
%         [max_val,index]=max(output{i});
%         
%         output{i}(index,1)=1;
%         output{i}(setdiff(1:r1,index),1)=0;
%         
%                 
%     end

    disp(speaker_op);