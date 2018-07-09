function [energy] = sp_get_energy(arr)
    energy = sum(abs(arr).^2);
end
    