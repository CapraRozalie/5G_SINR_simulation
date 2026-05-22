function score = scoreNetwork(metrics)

% WEIGHTS (tune these later)
wCoverage = 0.4;
wMean     = 0.3;
wEdge     = 0.3;   % 5th percentile SINR (cell-edge performance)

% NORMALIZATION (important for stability)

% coverage is already [0,1]
coverage = metrics.coverage;

% SINR metrics are in dB → normalize to reasonable range
meanSINR = metrics.meanSINR;
edgeSINR = metrics.sinr5th;

% soft normalization (prevents dominance by extreme values)
meanScore = tanh(meanSINR / 10);
edgeScore = tanh(edgeSINR / 10);

% FINAL SCORE
score = ...
    0.35 * coverage + ...
    0.25 * tanh(meanSINR/10) + ...
    0.25 * tanh(edgeSINR/10) - ...
    0.15 * tanh(metrics.sinrStd/10)

end