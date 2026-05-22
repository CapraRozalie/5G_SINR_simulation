function myMap(txsConfig, rxConfig)

bestScore = -inf;
bestConfig = struct();

fq = 3.5e9;

for downtilt = [10 15 20]

    for powerDBm = [30 40]

        for nrTrans = [3 4 6]

            for nrow = [4 8 16]

                for dBdown = [20 30 40]

                    config = struct();

                    config.fq = fq;
                    config.txPowerDbm = powerDBm;
                    config.nrTrans = nrTrans;
                    config.nrow = nrow;
                    config.ncol = nrow;
                    config.dBdown = dBdown;
                    config.downtilt = downtilt;

                    try
                        txs = buildNetwork(txsConfig, config);
                    catch ME
                        warning("Configuration failed: %s", ME.message);
                        continue;
                    end
                    
                    fprintf("SIM | tilt=%d | power=%d dBm | nrTrans=%d | nrow=%d | dBdown=%d\n", ...
                        downtilt, powerDBm, nrTrans, nrow, dBdown);


                    try
                        sinrValues = computeSINR(rxConfig,txs);
                    catch ME
                        warning("SINR computation failed: %s", ME.message); 
                        continue;
                    end


                    try
                        currentScore = scoreNetwork(sinrValues);
                    catch ME
                        warning("Scoring failed: %s", ME.message);
                        continue;
                    end

                    if(currentScore > bestScore)
                        bestScore = currentScore;
                        bestConfig = config;
                    end
                    
                end
            end
        end
    end
end

if isempty(fieldnames(bestConfig))
    warning("No valid configuration found.");
end

txs = buildNetwork(txsConfig, bestConfig);
displayNetwork(txs, rxConfig);
fprintf("simulations finished");

end
