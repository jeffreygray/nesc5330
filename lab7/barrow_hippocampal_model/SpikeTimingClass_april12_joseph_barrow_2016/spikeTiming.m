function [w] = spikeTiming( Zj, ZjBar, ZiBar, weightList, muSpike)
  % Parameters:
  %   Zj = {0, 1}
  %   ZjBar = [0, 1]
  %   ZiBar = [0, 1]+
  %   weightList = [0, 1]+
  %   muSpike = [0, inf.)

  w = weightList + muSpike * Zj .* ((1.0 - ZjBar) * ZiBar - weightList);
end % function

% As a test, you can run:
%   spikeTiming([1 0; 0 1; 1 1], 1, .5, [.4 .4 .4], 3)
% And you get results:
%   [.1 .2 .05]
% Similarly, running:
%   spikeTiming([1 0; 0 1; 0 0], 1, .5, [.4 .4 .4], 3)
% Yields:
%   [.1 .2 .4]
