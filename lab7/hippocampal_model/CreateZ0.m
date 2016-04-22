function [z] = CreateZ0(ni, Activity)
%Creates a static Z0 vector to be used on the first step of each trial in the
%absence of data from NeuroJet. This data is meant to be converted into a
%sparse matrix with spconvert()
    z = zeros(ni*Activity,3);
    z(:,1) = 1;
    z(:,3) = 1;
    z(:,2) = randperm(ni)(1:(ni*Activity));
    z(ni*Activity+1,1) = floor(1);
    z(ni*Activity+1,2) = floor(ni);
    z(ni*Activity+1,3) = floor(0);
end
