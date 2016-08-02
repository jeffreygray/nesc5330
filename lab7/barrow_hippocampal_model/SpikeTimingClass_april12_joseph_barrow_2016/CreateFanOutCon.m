function [FanOutCon, cOutMatrix] = CreateFanOutCon(cInMatrix)
% Function to generate the outward connection matrices for a network
% given input connection matrix. It creates a FanOutCon, which gives
% the number of outward connections per matrix, and the cOutMatrix,
% which gives the actual connections.

    FanOutCon = ones(1, size(cInMatrix, 1));
    for i = 1:size(cInMatrix, 1)
        FanOutCon(i) = nnz(cInMatrix==i-1);
    end % for

    cOutMatrix = zeros(size(cInMatrix, 1), max(FanOutCon));
    for i = 1:size(cOutMatrix, 1)
        [x, y] = find(cInMatrix==i-1);
        cOutMatrix(i, 1:length(x)) = sort(x);
    end % for
    cOutMatrix = cOutMatrix - 1;
end % function
