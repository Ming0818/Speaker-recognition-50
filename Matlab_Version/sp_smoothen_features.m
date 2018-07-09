function [ feat ] = sp_smoothen_features( features,smooth_factor )
%SP_SMOOTHEN_FEATURES Summary of this function goes here
%   Detailed explanation goes here
[r , c] = size(features);

for i = 1:c
    column_mean = mean(features(:,i));
    features(:,i)=features(:,i)-column_mean;
    
    column_max = max(features(:,i));
    features(:,i) = features(:,i)/column_max;
end

n=smooth_factor;

for i = 1:c
    for t = 1:r
        if t == 1
            feat(t,i) = features(t,i); 
        elseif t <n
            feat(t,i) = mean(features(1:t,i));
        else
            feat(t,i) = mean(features(t-n+1:t,i));
        end
    end
end

end

