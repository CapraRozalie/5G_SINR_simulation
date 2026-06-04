function config = decodeGA(x, numTowers, fq)

config = struct();

config.fq = fq;

idx = 1;

for i = 1:numTowers

    config.txPowerDbm(i) = x(idx);
    idx = idx + 1;

    config.nrTrans(i) = round(x(idx));
    idx = idx + 1;

    config.downtilt(i) = x(idx);
    idx = idx + 1;

    config.nrow(i) = round(x(idx));

    config.ncol(i) = config.nrow(i);

    idx = idx + 1;

    config.dBdown(i) = x(idx);
    idx = idx + 1;

end

end