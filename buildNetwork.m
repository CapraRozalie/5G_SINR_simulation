function txs = buildNetwork(params, config)

% PARAMETERS

fq = config.fq;

towers = params.towers;

txs = txsite.empty;

lambda = physconst("lightspeed")/fq;

drow = lambda/2;
dcol = lambda/2;

% CREATE TX SITES

for i = 1:params.numTowers

    lat = towers(i,1);
    lon = towers(i,2);
    h   = towers(i,3);

    % PER-TOWER PARAMETERS

    txPowerDBm = config.txPowerDbm(i);

    txPower = 10.^((txPowerDBm-30)/10);

    nrTrans = round(config.nrTrans(i));

    nrow = round(config.nrow(i));

    ncol = nrow;

    dBdown = config.dBdown(i);

    downtilt = config.downtilt(i);

    % Ensure valid sector count

    if mod(360,nrTrans) ~= 0

        continue;

    end

    % SECTOR ANGLES

    sectorSpacing = 360 / nrTrans;

    sectorAngles = ...
        sectorSpacing/2 : ...
        sectorSpacing : ...
        360 - sectorSpacing/2;

    % TAPER

    taperz = chebwin(nrow,dBdown);
    tapery = chebwin(ncol,dBdown);
    tap = taperz * tapery.';

    % PATCH ELEMENT

    patchElement = design(patchMicrostrip, fq);

    patchElement.Width = patchElement.Length;

    patchElement.Tilt = 90;

    patchElement.TiltAxis = [0 1 0];

    % ARRAY

    cellAntenna = phased.URA( ...
        Size=[nrow ncol], ...
        Element=patchElement, ...
        ElementSpacing=[drow dcol], ...
        ArrayNormal="x", ...
        Taper=tap);

    idx = length(txs);

    % CREATE SECTORS

    for ang = sectorAngles

        tx = txsite( ...
            Name =  "Tower " + i + ...
                    " Sector " + ang, ...
            Latitude = lat, ...
            Longitude = lon, ...
            AntennaHeight = h, ...
            AntennaAngle = [ang ; -downtilt], ...
            TransmitterFrequency = fq, ...
            TransmitterPower = txPower);

        tx.Antenna = cellAntenna;

        txs(idx+1) = tx;

        idx = idx + 1;

    end

end

end