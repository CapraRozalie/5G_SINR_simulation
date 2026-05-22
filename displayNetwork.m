function displayNetwork(txs, rxConfig)

if isempty(txs)
    error("txs is empty. Nothing to display.");
end

% MAP VIEW
viewer = siteviewer;
viewer.Basemap = "topographic";

show(txs);

% RECEIVER PARAMETERS (consistent with simulation)
bw = rxConfig.bw;
rxNoiseFigure = rxConfig.rxNoiseFigure;
rxAntennaHeight = rxConfig.rxAntennaHeight;

rxNoisePower = -174 + 10*log10(bw) + rxNoiseFigure;

rxGain = 0;

% SINR VISUALIZATION (ONLY for display, not scoring)
sinr(txs, "close-in", ...
    ReceiverGain = rxGain, ...
    ReceiverAntennaHeight = rxAntennaHeight, ...
    ReceiverNoisePower = rxNoisePower, ...
    MaxRange = 200, ...
    Resolution = 5);

end