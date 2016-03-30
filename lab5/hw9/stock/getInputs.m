function inputs = getInputs()

numInputLines = 16;
numCategories = 4;
numPatternsPerCategory = 4;
inputs = zeros(numInputLines, numCategories * numPatternsPerCategory);

% inputs(1:8, 1:4) = 1;
% inputs(9:16, 5:8) = 1;
% inputs([1:4 13:16], 9:12) = 1;
% inputs(5:12, 13:16) = 1;

inputs(1:8, 1:8) = 1;
inputs(9:16, 9:16) = 1;

end
