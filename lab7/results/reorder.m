function result = reorder(inputMat,reorderMat);

%REORDER - Reorder firing patterns
%   REORDER(inputMat) returns inputMat with its rows reordered such that the 
%   first non-zero value in each row is either in the same column or to the 
%   right (greater column index) of the first non-zero value in the rows 
%   before it.
%
%   REORDER(inputMat, reorderMat) returns the data from inputMat,reordered
%   based on reorderMat. (The same transform is performed on inputMat that
%   would have been performed on reorderMat had the call been 
%   REORDER(reorderMat).)
%
%   REORDER can be combined with THIN to create some snazzy reordered and 
%   thinned diagrams, a la Dave Sullivan.
%   
%   Example:
%   Given a matrix of neuronal firing data, FIRED, one might do the following:
%   
%   SPY(THIN(REORDER(FIRED)));
%
%   See also THIN.
%
% Copyright (c) 2005, Aprotim Sanyal
% modified by Andrew Howe 2007

    if ( ( nargin > 2) )
        error('ERROR:function takes 1 or 2 arguments')
    end

    if nargin == 1;
        reorderMat = inputMat;
    end;

    StartTimes = ones(size(reorderMat,1),1).*(1+size(reorderMat,2));
    for n = size(reorderMat,2):-1:1;
        firing = find(reorderMat(:,n));
        StartTimes(firing) = n; 
    end;

    [junk, indices] = sort(StartTimes);
    result = inputMat(indices,:);

return
