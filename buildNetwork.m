function txs = buildNetwork(params, config)

% PARAMETERS

fq = config.fq;

txPowerDBm = config.txPowerDbm;
txPower = 10.^((txPowerDBm-30)/10);

nrTrans = config.nrTrans;

if mod(360,nrTrans) ~= 0
    error("nrTrans must divide 360 evenly.");
end

sectorAngles = 0 : 360/nrTrans : 360 - 360/nrTrans;

towers = params.towers;

txs = txsite.empty;

% ANTENNA ARRAY SETTINGS

nrow = config.nrow;
ncol = config.ncol;

lambda = physconst("lightspeed")/fq;

drow = lambda/2;
dcol = lambda/2;

dBdown = config.dBdown;

% CREATE PATCH ELEMENT (single element model)

patchElement = design(patchMicrostrip,fq);
patchElement.Width = patchElement.Length;
patchElement.Tilt = 90;
patchElement.TiltAxis = [0 1 0];

% CREATE ARRAY (URA)

cellAntenna = phased.URA( ...
    Size=[nrow ncol], ...
    Element=patchElement, ...
    ElementSpacing=[drow dcol]);

% CREATE TX SITES

for i = 1:params.numTowers

    lat = towers(i,1);
    lon = towers(i,2);
    h   = towers(i,3);

    for ang = sectorAngles

        tx = txsite( ...
            Name = "Tower " + i + " Sector " + ang, ...
            Latitude = lat, ...
            Longitude = lon, ...
            AntennaHeight = h, ...
            AntennaAngle = ang, ...
            TransmitterFrequency = fq, ...
            TransmitterPower = txPower);

        tx.Antenna = cellAntenna;

        txs(end+1) = tx;

    end
end

end