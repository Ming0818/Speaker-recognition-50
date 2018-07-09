function[Ea Ed]=emo_wenergy(arr,wavlet,levelOfDecomp)

%[DecompVector L]=wavedec(arr,levelOfDecomp,wavlet);
%[Ea Ed] = wenergy(DecompVector,L);
[DecompMat]=emo_dwt2(arr,wavlet,levelOfDecomp);
for i=1:length(DecompMat)
    L(1,i)=length(DecompMat{i});
end

DecompVector=[];
for i=1:length(DecompMat)
    DecompVector=[DecompVector DecompMat{1,i}];
end

%level 4 decomposition only
en(1,1)=sum(DecompVector(1,1:L(1,1)).^2);
en(1,2)=sum(DecompVector(1,L(1,1)+1:L(1,1)+L(1,2)).^2);
en(1,3)=sum(DecompVector(1,L(1,1)+L(1,2)+1:L(1,1)+L(1,2)+L(1,3)).^2);
en(1,4)=sum(DecompVector(1,L(1,1)+L(1,2)+L(1,3)+1:L(1,1)+L(1,2)+L(1,3)+L(1,4)).^2);
en(1,5)=sum(DecompVector(1,L(1,1)+L(1,2)+L(1,3)+L(1,4)+1:L(1,1)+L(1,2)+L(1,3)+L(1,4)+L(1,5)).^2);

Ten=sum(en);

for i=1:length(DecompMat)
    if i==length(DecompMat)
        Ea=(en(1,i)/Ten)*100;
    else
        Ed(1,i)=(en(1,i)/Ten)*100;
    end
end