function generate(txsConfig, rxConfig, workFq)

% ==========================================
% VARIABLES PER TOWER:
% power
% sectors
% downtilt
% nrow/ncol
% taper

% +freq
% ==========================================

numTowers = txsConfig.numTowers;

fq = workFq;

varsPerTower = 5;

nvars = numTowers * varsPerTower;

% LOWER / UPPER BOUNDS

lb = [];
ub = [];

for i = 1:numTowers

    lb = [lb ...
        30 ... % power
        3 ...  % sectors
        0 ...  % downtilt
        4 ...  % array size
        20];   % taper

    ub = [ub ...
        46 ...
        8 ...
        20 ...
        16 ...
        40];

end

% INTEGER VARIABLES

intcon = [];

for i = 1:numTowers

    base = (i-1)*varsPerTower;

    intcon = [intcon ...
        base+2 ... % nrTrans
        base+4];   % nrow

end

% OBJECTIVE FUNCTION
fitnessFcn = @(x) evaluateGA(x, txsConfig, rxConfig, fq);

% GA SETTINGS

options = optimoptions('ga', ...
    'PopulationSize',25,...
    'MaxGenerations',20,...
    'Display','iter',...
    'UseParallel',false);

% RUN OPTIMIZER

[xBest, fBest] = ga( ...
    fitnessFcn,...
    nvars,...
    [],[],[],[],...
    lb,...
    ub,...
    [],...
    intcon,...
    options);

% BUILD BEST NETWORK

bestConfig = decodeGA(xBest, numTowers, fq);

disp(bestConfig)

txs = buildNetwork(txsConfig, bestConfig);

displayNetwork(txs, rxConfig);

fprintf("\nBEST SCORE = %.3f\n", -fBest);
end