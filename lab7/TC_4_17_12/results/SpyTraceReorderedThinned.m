function spyme = SpyTraceReorderedThinned(me, samples, inputMat, reorderMat, pre )

% SpyTraceReorderedThinned - returns a matrix ready for viewing with SPY
%
% inMat is the matrix you would like to reorder
% reorderMat is the matrix reordering will be based on
% me is the number of externally activated neurons
% samples is the number of samples you would like displayed in the
% reordered part
%
% Copyright (c) 2005 Andrew Howe

    if nargin == 3;
        reorderMat = inputMat;
    end;

    if size(size(inputMat)) ~= 2;
        exit;
    end

    sizeMaster=size(inputMat);

    if ( sizeMaster(1) < sizeMaster(2) )
        inputMat=inputMat';
        sizeMaster=size(inputMat);
    end

    sizeReorder=size(reorderMat);

    if ( sizeReorder(1) < sizeReorder(2) )
        reorderMat=reorderMat';
        sizeReorder=size(reorderMat);
    end

    nonExternalStart=((me*2)+1);
    reordered=reorder(inputMat(nonExternalStart:sizeMaster(1),(pre+1):(sizeMaster(2))));
    now_thin=thin(reordered, samples);
    spyme=([ inputMat(1:(2*me),(pre+1):(sizeMaster(2))) ; now_thin ]);

return;
