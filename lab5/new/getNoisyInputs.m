
function [noisy_data] = getNoisyInputs(proto)
    noisy_data = proto;
    
    for i = 1 : 2
        pos_val = find(proto > 0);
        x = ceil(rand(1) * length(pos_val));
        noisy_data(pos_val(x)) = 0;
    end
    
    for i = 1 : 2
        zero_val = find(proto ==  0);
        x = ceil(rand(1) * length(zero_val));
        noisy_data(zero_val(x)) = 1;
    end 
end

