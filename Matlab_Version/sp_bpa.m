function[dw,error]=sp_bpa(x,d,act_fn,net,eta,init_weights)
%x=[0 0 1 1;0 1 0 1];d=[0 1 1 0];net=[3,2,1];
%a=sym('x');act_fn={1/(1+exp(-1*a)),a};

[m,N]=size(x);
[m2,N2]=size(d);
if (N2~=N)||(m2~=net(end))
    disp('Invalid `data set or group.Please input correctly');
end

NoOfLayers=length(net);
NoOfHiddenLayers=length(net)-1;
NoOfOutputs=net(end);


if nargin==6
    for i=1:NoOfLayers
        w{i}=init_weights{i};
    end
else
    for i=1:NoOfLayers
        if i==1
            w{i}=zeros(net(i),m+1);
        else
            w{i}=zeros(net(i),net(i-1)+1);
        end
    end
end

if nargin<5
    eta(1,1:NoOfLayers)=0.41;
end

k=1;

        y{1}=[1;x];
        for i=1:NoOfLayers
            v{i}=w{i}*y{i};
            if i~=NoOfLayers
                y{i+1}=subs(act_fn{1},'x',v{i});
                y{i+1}=[1;y{i+1}];
            else
                y{i+1}=subs(act_fn{2},'x',v{i});
            end
        end
        
        e=d-y{NoOfLayers+1};
        error(:,k)=e;k=k+1;
        for i=NoOfLayers:-1:1
            if i==NoOfLayers
                del{i}=e.*subs(diff(act_fn{2}),'x',v{i});
            else
                del{i}=((w{i+1}(:,2:end))'*del{i+1}).*subs(diff(act_fn{1}),'x',v{i});
            end
            dw{i}=eta(1,i)*del{i}*y{i}';
             
        end
        
        
        
%         %for testing
%         k3=1;
%         for iter2=1:N
%             y2{1}=[1;x(:,iter2)];
%             for i=1:NoOfLayers
%                 v{i}=w{i}*y2{i};
%                 if i~=NoOfLayers
%                     y2{i+1}=subs(act_fn{1},'x',v{i});
%                     y2{i+1}=[1;y2{i+1}];
%                 else
%                     y2{i+1}=subs(act_fn{2},'x',v{i});
%                 end
%             end
%             output{k3,iter}=y2{NoOfLayers+1};k3=k3+1;
%         end
               



%     for iter=1:N
%         y{1}=[1;x(:,iter)];
%         
%         for i=1:NoOfLayers
%             v{i}=w{i}*y{i};
%             if i~=NoOfLayers
%                 y{i+1}=subs(act_fn{1},'x',v{i});
%                 y{i+1}=[1;y{i+1}];
%             else
%                 y{i+1}=subs(act_fn{2},'x',v{i});
%             end
%         end
%         output{1,iter}=y{NoOfLayers+1};
%     end
end
    