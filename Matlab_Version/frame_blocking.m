function [frame]=frame_blocking(y)
    n=256;
    %m=100;
    nn = floor(n/2);
    if length(y) > nn
    no_frames= ceil(length(y)/n);
    %frame=zeros(no_frames+1,n);
    for i = 1:no_frames
        temp=y(((i-1)*nn)+1:((i-1)*nn)+256);
        frame(i,1:n)=temp;
    end
    else frame = y;
    end
    end
    

