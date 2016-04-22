function result = thin(inMat, desiredNum)

%THIN - evenly sample rows of a matrix
%   THIN(inputMat, N) will return an MxN matrix of data from inputMat, where
%   M is the width of inputMat.  The returned matrix consists of lines of the 
%   original inputMat, sampled evenly to result in N rows of data.
%
%   When used with REORDER, this can be used to good effect to display otherwise
%   confusing and dense data.
%
%   See also REORDER.
%
% Copyright (c) 2005, Aprotim Sanyal
% modified by Andrew Howe 2007

    if ( nargin ~= 2)
        error('ERROR:function takes 2 arguments')
    end

    samprate = floor (size(inMat,1)/desiredNum);
    result = inMat(1:samprate:size(inMat,1),:);

return;
