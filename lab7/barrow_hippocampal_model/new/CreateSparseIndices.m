function [row, col] = CreateSparseIndices(ni, connectivity, fanInCon)
  row = repmat((1:ni), ni*connectivity, 1)'';
  row = row(:)-1;
  fTr = fanInCon';
  col = fTr(:);
end
