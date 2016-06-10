% MutualInformation: returns mutual information (in bits) of the 'X' and 'Y'%
% I = MutualInformation(X,Y);
%
% I  = calculated mutual information (in bits)
% X  = variable(s) to be analyzed (column vector)
% Y  = variable to be analyzed (column vector)
%


function I = MutualInformation(X,Y);

if (size(X,2) > 1)  % More than one predictor?
    % Axiom of information theory
    I = JointEntropy(X) + chaosFull(Y) - JointEntropy([X Y]);
else
    % Axiom of information theory
    I = chaosFull(X) + chaosFull(Y) - JointEntropy([X Y]);
end




