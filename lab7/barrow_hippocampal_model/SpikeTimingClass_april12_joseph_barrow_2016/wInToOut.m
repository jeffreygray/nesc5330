function [ wOutMatrix ] = wInToOut( wInMatrix, RowIn, ColIn, ni, fanOutCon )
  wOutMatrix = zeros(ni, max(fanOutCon)) - 2;

  wT = wInMatrix';
  wT(wT == 0) = -1;
  wT(wT == -2) = 0;

  ST = sparse(RowIn+1, ColIn+1, wT(:));
  ST = ST';

  for i = 1:ni
    fSTi = full(ST(i, :));
    fSTi(fSTi==0) = [];
    wOutMatrix(i, 1:fanOutCon(i)) = fSTi;
  end

  wOutMatrix(wOutMatrix == -1) = 0.0;
end



%  for j = 1:size(cInMatrix, 2)
%    for i = 1:size(cInMatrix, 1)
%      if(cInMatrix(i, j) >= 0)
%        cur = cInMatrix(i, j) + 1;
%        current(cur) = current(cur) + 1;
%        wOutMatrix(cur, current(cur)) = wInMatrix(i, j);
%      end
%    end
%  end
