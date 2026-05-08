function myMap(params)

bestScore = -inf;
bestConfig = struct();

fq = 3.5e9;

for downtilt = [0 10 20]

    for powerDBm = [30 45]

        for nrTrans = [3 4 6]

            for nrow = [8 16]

                for dBdown = [20 40]

                    config = struct();

                    config.fq = fq;
                    config.txPowerDbm = powerDBm;

                    config.nrTrans = nrTrans;

                    config.nrow = nrow;
                    config.ncol = nrow;

                    config.dBdown = dBdown;

                    config.downtilt = downtilt;

                    try
                        txs = buildNetwork(params, config);
                    catch ME
                        warning("Configuration failed: %s", ME.message);
                        continue;
                    end
                    
                    fprintf("SIM | tilt=%d | power=%d dBm | nrTrans=%d | nrow=%d | dBdown=%d\n", ...
                        downtilt, powerDBm, nrTrans, nrow, dBdown);

                    %if scor > bestScore
                    %    bestScore = scor;
                    %    bestConfig = config;
                    %end

                end
            end
        end
    end
end

%if isempty(fieldnames(bestConfig))
%    error("No valid configuration found.");
%end

txs = buildNetwork(params, config);
displayNetwork(txs, params);

end