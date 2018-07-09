function[no_zcr]=sp_get_zcrs(arr)
no_zcr=0;
    for i=1:length(arr)
        if i==1
            if arr(i)>=0
                pos=1;
            else
                pos=-1;
            end
        else
            if (arr(i)>=0)&&(pos==-1)
                no_zcr=no_zcr+1;
                pos=1;
            elseif (arr(i)<0)&&(pos==1)
                no_zcr=no_zcr+1;
                pos=-1;
            end
        end         
    end
end