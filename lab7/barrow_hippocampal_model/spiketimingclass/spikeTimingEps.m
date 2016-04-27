function [weightList] = spikeTimingEps(Z_post, muSpike, epsFold, weightList, lookback)
    % First we need to focus on the appropriate firings, so we choose
    % the previous "lookback" number of elements.
    lookback = min(lookback, size(Z_post, 2));
    Z_post = Z_post(:, end-lookback+1:end);
    epsFoldVec = zeros(1, lookback);

    for i = 1:lookback
      epsFoldVec(i) = -(epsFold ^ (i));
    end

    for i = 1:size(Z_post, 1)
      weightList(i) = weightList(i) + muSpike * dot(Z_post(i, :), epsFoldVec) * weightList(i);
    end
end % function

% As a test, you can run:
%   spikeTimingEps([1 0; 0 1; 1 1], 1, .5, [.4 .4 .4], 3)
% And you get results:
%   [.3 .2 .1]
% Similarly, running:
%   spikeTimingEps([1 0; 0 1; 0 0], 1, .5, [.4 .4 .4], 3)
% Yields:
%   [.3 .2 .4]
