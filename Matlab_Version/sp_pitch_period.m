function[pitch_period1, pitch_period2, pitch_period3]=sp_pitch_period(arr,Fs)
    %pitch range 2.5-10ms
%     if length(arr)>=round(0.3*Fs)
%         xcorr_arr=xcorr(arr(1,1:0.3*Fs));
%         [~,max_index]=max(xcorr_arr);
%         for i=1:floor(length(arr)/2)
%             if xcorr_arr(1,max_index+i)>xcorr_arr(1,max_index+i-1)
%                 min_index_delay=i-1;
%                 break;
%             end
%         end
%         temp_arr=xcorr_arr(1,max_index+min_index_delay+1:end);
%         [~,max_index2]=max(temp_arr);
%         
%         pitch_period=(min_index_delay+max_index2)/Fs;
%     else
        xcorr_arr=xcorr(arr);
        %plot(xcorr_arr);
        [~,max_index]=max(xcorr_arr);
        %plot(xcorr_arr(max_index:1000));
        
        for i=1:floor(length(arr)/2)
            if xcorr_arr(1,max_index+i)>xcorr_arr(1,max_index+i-1)
                min_index_delay=i-1;
                break;
            end
        end
        temp_arr=xcorr_arr(1,max_index+min_index_delay+1:end);
        [~,max_index2]=max(temp_arr);
        
        pitch_period1=(min_index_delay+max_index2)/Fs;
        
        %------------------------------------------------
        samples1=max_index+min_index_delay+max_index2;
        for i=1:floor(length(arr)/2)
            if xcorr_arr(1,samples1+i)>xcorr_arr(1,samples1+i-1)
                min_index_delay2=i-1;
                break;
            end
        end
        temp_arr=xcorr_arr(1,samples1+min_index_delay2+1:end);
        [~,max_index3]=max(temp_arr);
        
        pitch_period2=(min_index_delay2+max_index3)/Fs;
        
        %------------------------------------------------------
        samples2=samples1+min_index_delay2+max_index3;
        for i=1:floor(length(arr)/2)
            if xcorr_arr(1,samples2+i)>xcorr_arr(1,samples2+i-1)
                min_index_delay3=i-1;
                break;
            end
        end
        temp_arr=xcorr_arr(1,samples2+min_index_delay3+1:end);
        [~,max_index4]=max(temp_arr);
        
        pitch_period3=(min_index_delay3+max_index4)/Fs;
   % end
    

end
