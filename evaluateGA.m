function cost = evaluateGA(x, txsConfig, rxConfig, fq)

try
    config = decodeGA(x, txsConfig.numTowers, fq);

    txs = buildNetwork(txsConfig, config);

    metrics = computeSINR(rxConfig, txs);

    score = scoreNetwork(metrics);

    fprintf("score = %.4f\n",score);

    cost = -score;

catch ME
    warning(ME.message);
    cost = 1e9;
end

end