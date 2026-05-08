function displayNetwork(txs,params)

if isempty(txs)
    error("txs is empty. Nothing to display.");
end

%% RECEIVER PARAMETERS

bw = 20e6; % 20 MHz bandwidth
rxNoiseFigure = 7; % dB
rxNoisePower = -174 + 10*log10(bw) + rxNoiseFigure;
rxGain = 0; % dBi
rxAntennaHeight = 1.5; % m

%% MAP

viewer = siteviewer;
viewer.Basemap = "topographic";

show(txs)

%% SINR MAP

sinr(txs,"close-in", ...
    ReceiverGain = rxGain, ...
    ReceiverAntennaHeight = rxAntennaHeight, ...
    ReceiverNoisePower = rxNoisePower, ...
    MaxRange = 200, ...
    Resolution = 5);

end