function [avg , std_dev] = get_avg_stddev(x)
    n = length(x);
avg =  mean(x);
std_dev = sqrt(sum((x-avg).^2/n));