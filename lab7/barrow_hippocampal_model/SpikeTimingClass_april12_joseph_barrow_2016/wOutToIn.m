function [ wInMatrix ] = wOutToIn( wOutMatrix, RowOut, ColOut, ni, fanInCon )
  wInMatrix = zeros(ni, max(fanInCon)) - 2;

  wT = wOutMatrix';
  wT(wT == 0) = -1;
  wT(wT == -2) = [];

  ST = sparse(RowOut+1, ColOut+1, wT(:));
  ST = ST';

  for i = 1:ni
    fSTi = full(ST(i, :));
    fSTi(fSTi==0) = [];
    wInMatrix(i, 1:fanInCon(i)) = fSTi;
  end

  wInMatrix(wInMatrix == -1) = 0.0;
end

%  for i = 1:size(cInMatrix, 1)
%    for j = 1:size(cInMatrix, 2)
%      current = cInMatrix(i, j) + 1;
%      if(current == 0)
%        continue;
%      end
%
%      [x, y] = find(cOutMatrix(current,:)==i-1);
%      x = x(1); y = y(1);
%      cOutMatrix(current, y) = -1;
%
%      wInMatrix(i, j) = wOutMatrix(current, y);
%    end
%  end
