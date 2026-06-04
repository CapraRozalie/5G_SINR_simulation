function score = scoreNetwork(metrics)

coverage = metrics.coverage;
meanSINR = metrics.meanSINR;
edgeSINR = metrics.sinr5th;
stdSINR = metrics.sinrStd;

% Normalize metrics

coverageScore = coverage;
meanScore = tanh(meanSINR / 10);
edgeScore = tanh(edgeSINR / 10);
stdPenalty = tanh(stdSINR / 15);

% Weights

wCoverage = 0.40;
wMean = 0.25;
wEdge = 0.25;
wStd = 0.10;

score = wCoverage * coverageScore + wMean * meanScore + wEdge * edgeScore - wStd * stdPenalty;

fprintf( "\ncov=%.2f mean=%.2f edge=%.2f std=%.2f score=%.3f\n", ...
    coverage,...
    meanSINR,...
    edgeSINR,...
    stdSINR,...
    score);

end