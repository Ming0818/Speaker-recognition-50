function[DcompMat]=emo_dwt2(arr,wavlet,levelOfDecomp)
    
   [cA,cD]=dwt(arr,wavlet);

   [rows2 columns2]=size(cA);
     if columns2==1
        cA=cA';
        cD=cD';
     end
     
   
   DcompMat{1,1}=cD;
   %DcompMat{2,1}=abs(fft(cD));
   
   if levelOfDecomp>(log(length(arr))/log(2))
       disp('Number of levels of decomposition entered, exceeds the maximum possible number of decompositions');
   end

   if levelOfDecomp>1&&levelOfDecomp<=(log(length(arr))/log(2))
      for i=2:levelOfDecomp 
          %if mod(length(cA),2)~=0
           %  cA=[cA zeros(1,1)];
          %end
     
        [cA,cD]=dwt(cA,wavlet);
          
          if i<levelOfDecomp
             DcompMat{1,i}=cD;
             %DcompMat{2,i}=abs(fft(cD));
          end
          
          if i==levelOfDecomp
         
             DcompMat{1,i}=cD;
             %DcompMat{2,i}=abs(fft(cD));  
             DcompMat{1,i+1}=cA;
             %DcompMat{2,i+1}=abs(fft(cA));
          end
      end
   end

   if levelOfDecomp==0
      for i=2:(log(length(eeg.data))/log(2))
    
          %if mod(length(cA),2)~=0
          %  cA=[cA zeros(1,1)];
          %end
         
          [cA,cD]=dwt(cA,wavlet);       
     
          if i<(log(length(arr))/log(2))
             DcompMat{1,i}=cD;
             %DcompMat{2,i}=abs(fft(cD));
          end
      
          if i==(log(length(arr))/log(2))
             DcompMat{1,i}=cD;
             %DcompMat{2,i}=abs(fft(cD));  
             DcompMat{1,i+1}=cA;
             %DcompMat{2,i+1}=abs(fft(cA));
          end
      end
   end


end