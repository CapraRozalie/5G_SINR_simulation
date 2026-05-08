function txs = buildNetwork(params, config)

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
    
            txs(end+1) = tx;
        end
    end

    %% ANTENNA PATTERN
    
    % Define pattern parameters
    azvec = -180:180;
    elvec = -90:90;
    
    Am = 30;
    tilt = 0;
    az3dB = 65;
    el3dB = 65;
    
    % Define antenna pattern
    [az,el] = meshgrid(azvec,elvec);
    
    azMagPattern = -12*(az/az3dB).^2;
    elMagPattern = -12*((el-tilt)/el3dB).^2;
    
    combinedMagPattern = azMagPattern + elMagPattern;
    combinedMagPattern(combinedMagPattern < -Am) = -Am; % Saturate at max attenuation
    
    phasepattern = zeros(size(combinedMagPattern));
    
    % Create antenna element
    antennaElement = phased.CustomAntennaElement( ...
        AzimuthAngles = azvec, ...
        ElevationAngles = elvec, ...
        MagnitudePattern = combinedMagPattern, ...
        PhasePattern = phasepattern);

    %% ARRAY CONFIG 

    % Define array size
    nrow = config.nrow;
    ncol = config.ncol;
    
    % Define element spacing
    lambda = physconst("lightspeed")/fq;
    drow = lambda/2;
    dcol = lambda/2;
    
    % Define taper to reduce sidelobes 
    dBdown = config.dBdown;
    taperz = chebwin(nrow,dBdown);
    tapery = chebwin(ncol,dBdown);
    tap = taperz*tapery.'; % Multiply vector tapers
    
    % Create nrow x ncol antenna array
    cellAntenna = phased.URA(Size=[nrow ncol],...
        Element=antennaElement,...
        ElementSpacing=[drow dcol],...
        Taper=tap,...
        ArrayNormal="x");

    %% arr element config
    % Design half-wavelength rectangular microstrip patch antenna
    patchElement = design(patchMicrostrip,fq);
    patchElement.Width = patchElement.Length;
    patchElement.Tilt = 90;
    patchElement.TiltAxis = [0 1 0];
    
    % Assign the patch antenna as the array element
    cellAntenna.Element = patchElement;

    %% ASSIGN ANTENNAS
    
    for k = 1:length(txs)
        txs(k).Antenna = cellAntenna;
    end

end
