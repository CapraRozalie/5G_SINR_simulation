function metrics = computeSINR(rxConfig, txs)

% ==========================================
% RECIVER PARAMETERS:
% bandwidth
% noise figure
% antenna height
%
% + latitude & longitude center
% ==========================================
bw = rxConfig.bw;
nf = rxConfig.rxNoiseFigure;

noisePower_dBm = -174 + 10*log10(bw) + nf;
linearNoise = db2pow(noisePower_dBm);

numTx = numel(txs);

persistent rxs
persistent numRx

if isempty(rxs)

    latCenter = rxConfig.centerLat;
    lonCenter = rxConfig.centerLon;
    
    gridStep = 0.0004; % ~28 m resolution (much lighter than before)
    latVec = (latCenter - 0.005) : gridStep : (latCenter + 0.005);
    lonVec = (lonCenter - 0.005) : gridStep : (lonCenter + 0.005);
    %approx 1km x 1km 600-800 receiver points

    latPts = repelem(latVec(:), numel(lonVec));
    lonPts = repmat(lonVec(:), numel(latVec), 1);
    
    rxs = rxsite( ...
        "Latitude", latPts, ...
        "Longitude", lonPts, ...
        "AntennaHeight", rxConfig.rxAntennaHeight);
    
    numRx = numel(rxs);

end

prMatrix = zeros(numRx, numTx);

pm = propagationModel("close-in"); %freespace / close-in / rain / raytracing??

% Use FOR instead of PARFOR first
for k = 1:numTx

    try

        pr = sigstrength(rxs, txs(k),pm);

        % Remove insane values
        pr(~isfinite(pr)) = -300;

        prMatrix(:,k) = pr;

    catch

        prMatrix(:,k) = -300;

    end

end

linearPower = db2pow(prMatrix);

linearServ = max(linearPower, [], 2);

linearInterf = sum(linearPower, 2) - linearServ;

sinrLinear = linearServ ./ (linearInterf + linearNoise);

sinr_dB = pow2db(sinrLinear);

sinr_dB = sinr_dB(isfinite(sinr_dB));

metrics.meanSINR = mean(sinr_dB);
metrics.sinrStd  = std(sinr_dB);
metrics.sinr5th  = prctile(sinr_dB, 5);
metrics.coverage = mean(sinr_dB > 0);

end