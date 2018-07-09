function [ sp_op ] = run_final( )
%RUN_FINAL Summary of this function goes here
%   Detailed explanation goes here
load audio_gui.mat  
load Fs.mat
load seed_toolbox_1.mat

%w=final_weights;

%Fs=11025;
smooth_factor=1;
NoOfSeconds=2;
NoOfTrials=10;
NoOfLayers=length(net);
[r,c]=size(features);
a=sym('x');act_fn={1/(1+exp(-a)),a};




[filtered_audio]=sp_preprocessing(audio,Fs);
    
[features_test]=sp_feature_extraction(filtered_audio,Fs);

%[features_test,eig_val]=emo_pca(features_test,20);

features=[features;features_test];

feat=sp_smoothen_features( features,smooth_factor );

feat_test=feat(r+1:end,:);

[rows,col]=size(feat_test);

x=feat_test';
disp(network.IW)
disp(network.LW)
disp(network.b)

output = sim(network, x);

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
        [maxval1, index1] = max(output(:,i));
        speak_no(1,i) = index1;
        [max_val, index] = max(output(:,i));
        output(index,i) = 1;
        output(setdiff(1:r,index),i) = 0;
        
    end
    disp(speaker_op);
    sp_op=mode(speak_no)+1;

end
