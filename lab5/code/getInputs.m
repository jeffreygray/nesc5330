%   this function returns an input set along with a random mutation as well
%   as the resultant entropy value
function inputs = getInputs()

    numInputLines = 16;
    numCategories = 4;
    numPatternsPerCategory = 4;
    inputs = zeros(numInputLines, numCategories * numPatternsPerCategory);

    inputs(1:8, 1:4) = 1;
    inputs(9:16, 5:8) = 1;
    inputs([1:4 13:16], 9:12) = 1;
    inputs(5:12, 13:16) = 1;
    
    %   adding noise
    randX = randi([1, numCategories * numPatternsPerCategory]);
    randY = randi([1, numInputLines]);
    inputs(randX, :) = 0;
    ent = entropy(inputs);

    inputs(1:8, 1:8) = 1;
    inputs(9:16, 9:16) = 1;

end
