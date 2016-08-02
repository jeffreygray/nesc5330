% MutualInformation: returns mutual information between X and Y

function I = MutualInformation(X,Y);

if (size(X,2) > 1)  
    I = JointEntropy(X) + chaosFull(Y) - JointEntropy([X Y]);
else
    I = chaosFull(X) + chaosFull(Y) - JointEntropy([X Y]);
end




