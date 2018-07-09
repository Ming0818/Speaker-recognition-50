function [ output ] = round_up( output_in )
%ROUND_UP Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(output_in)
    for j = 1:length(output_in{i})
        if output_in{i}(j) > 0.7
            output{i}(j) = 1;
        else
            output{i}(j) = 0;
        end
    end
end

end

