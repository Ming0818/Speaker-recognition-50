
for i=4:15
    features(:,i) = mfcc_coeffs(:,i-2);
end

[r , c] = size(features);

for i = 1:c
    column_mean = mean(features(:,i));
    features(:,i)=features(:,i)-column_mean;
    column_max = max(features(:,i));
    features(:,i) = features(:,i)/column_max;
    
end
for i = 1:c
    for t = 1:r
        if t == 1
            feat(t,i) = features(t,i); 
        elseif t <10
            feat(t,i) = mean(features(1:t,i));
        else
            feat(t,i) = mean(features(t-9:t,i));
        end
    end
end