function[new_sig] = remove_trailing_zeros(y)

for j = length(y) : -1 : 1
        if y(j) ~= 0
            break;
        end
end

%new_sig = zeros(1, j);
%audio_stripped(i, j+1:end) = [];
new_sig(1,1:j) = y(1,1:j);
   
