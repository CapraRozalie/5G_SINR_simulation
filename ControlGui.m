function ControlGui()
height = 700;
width = 820;

f = figure('Position',[300 100 width height],'Name','TxSite Control');

towerList = [];

dy = 40; 
y = height - dy;

uicontrol(f,'Style','text','Position',[20 y 200 20],'String','Transmitter Towers');
y = y - dy;

% Latitude
uicontrol(f,'Style','text','Position',[20 y 150 20],'String','Latitude');
hLat = uicontrol(f,'Style','edit','Position',[200 y 120 25],'String','');

y = y - dy;

% Longitude
uicontrol(f,'Style','text','Position',[20 y 150 20],'String','Longitude');
hLong = uicontrol(f,'Style','edit','Position',[200 y 120 25],'String','');

y = y - dy;

% Height
uicontrol(f,'Style','text','Position',[20 y 150 20],'String','Antenna Height (m)');
hHeight = uicontrol(f,'Style','edit','Position',[200 y 120 25],'String','');

y = y - dy;

uicontrol(f,'Style','pushbutton',...
    'Position',[200 y 120 30],...
    'String','Add Tower',...
    'Callback',@addArrElement);

y = y - dy;

uicontrol(f,'Style','pushbutton',...
    'Position',[200 y 120 30],...
    'String','Remove Tower',...
    'Callback',@removeArrElement);

y = y - dy;

% Tower list display
hList = uicontrol(f,'Style','listbox',...
    'Position',[20 y-40 350 80],...
    'String',{});
y = y - 80;

%Min Tx params
uicontrol(f,'Style','text','Position',[20 y 200 20],'String','Min Transmission parameters');
y = y - dy;
% Power
uicontrol(f,'Style','text','Position',[20 y 150 20],'String','Antenna Power (dBm)');
hTxPower = uicontrol(f,'Style','edit','Position',[200 y 120 25],'String','');

y = y - dy;



% Downtilt
uicontrol(f,'Style','text','Position',[20 y 150 20],'String','Antenna Downtilt');
hDowntilt = uicontrol(f,'Style','edit','Position',[200 y 120 25],'String','');

y = y - dy;



% Taper
uicontrol(f,'Style','text','Position',[20 y 150 20],'String','Taper');
hTaper = uicontrol(f,'Style','edit','Position',[200 y 120 25],'String','');

y = y - dy;

% Frequency
uicontrol(f,'Style','text','Position',[20 y 150 20],'String','Antenna Frequency (Hz)');
hFreq = uicontrol(f,'Style','edit','Position',[200 y 120 25],'String','');

dy = 40; 
y = height - dy;

%Receiver params label
uicontrol(f,'Style','text','Position',[450 y 200 20],'String','Receiver Parameters');
y = y - dy;

%bandwidth
uicontrol(f,'Style','text','Position',[450 y 150 20],'String','Receiver bandwidth (Hz)');
hBw = uicontrol(f,'Style','edit','Position',[600 y 120 25],'String','20e6');
y = y - dy;

%noise figure
uicontrol(f,'Style','text','Position',[450 y 150 20],'String','Noise Figure (dB)');
hNf = uicontrol(f,'Style','edit','Position',[600 y 120 25],'String','7');
y = y - dy;

%Receiver antenna height
uicontrol(f,'Style','text','Position',[450 y 150 30],'String','Receiver Antenna Height (user equipment height) (m)');
hRxAntHeight = uicontrol(f,'Style','edit','Position',[600 y 120 25],'String','1.5');
y = y - dy;

%Receiver Center Latitude
uicontrol(f,'Style','text','Position',[450 y 150 20],'String','Center Latitude');
hRxCenterLat = uicontrol(f,'Style','edit','Position',[600 y 120 25],'String','45.6965410830449');
y = y - dy;

%Receiver Center Longitude
uicontrol(f,'Style','text','Position',[450 y 150 20],'String','Center Longitude');
hRxCenterLon = uicontrol(f,'Style','edit','Position',[600 y 120 25],'String','27.184755895723');


%MAX tx params
y = y - 120;
uicontrol(f,'Style','text','Position',[450 y 200 20],'String','Max Transmission parameters');
y = y - dy;
% Power
uicontrol(f,'Style','text','Position',[450 y 150 20],'String','Antenna Power (dBm)');
hTxPowerMax = uicontrol(f,'Style','edit','Position',[600 y 120 25],'String','');

y = y - dy;


% Downtilt
uicontrol(f,'Style','text','Position',[450 y 150 20],'String','Antenna Downtilt');
hDowntiltMax = uicontrol(f,'Style','edit','Position',[600 y 120 25],'String','');

y = y - dy;


% Taper
uicontrol(f,'Style','text','Position',[450 y 150 20],'String','Taper');
hTaperMax = uicontrol(f,'Style','edit','Position',[600 y 120 25],'String','');

y = y - dy;






% SINR checkbox
hSINR = uicontrol(f,'Style','checkbox',...
    'Position',[20 30 150 25],'String','Show SINR');

% Run button
uicontrol(f,'Style','pushbutton',...
    'Position',[250 30 120 30],...
    'String','Generate Map',...
    'Callback',@runSimulation);

% Documentation button
uicontrol(f,'Style','pushbutton',...
    'Position',[600 30 120 30],...
    'String','Documentation',...
    'Callback',@DocumentationButtonPushed);

    function addArrElement(~,~)

    lat = str2double(hLat.String);
    lon = str2double(hLong.String);
    h   = str2double(hHeight.String);
    


    if any(isnan([lat, lon, h]))
        errordlg('Invalid input values');
        return;
    end

    towerList(end+1,:) = [lat lon h];
    updateListBox();
    end

    function updateListBox()
        % Build display list

        listStr = sprintfc('Lat: %6.f | Lon: %6.f | H: %.2f ',...
            towerList(:,1:3));

        % Update GUI
        set(hList, 'String', listStr);

        drawnow;

        % Clear inputs
        hLat.String = '';
        hLong.String = '';

        end

    function removeArrElement(~,~)
        val = hList.Value;
        if isempty(towerList) || val > size(towerList, 1)
           return
        end
        towerList(val, :) = [];
        hList.Value = max(1, val-1);
        updateListBox();
    end




function runSimulation(~,~)

    if isempty(towerList)
        errordlg('No towers added!');
        return;
    end

    txsConfig.towers = towerList;
    txsConfig.showSINR = hSINR.Value;
    txsConfig.numTowers = size(towerList,1);

    %transmission params

    %min
    txsConfig.minPower = str2double(hTxPower.String);
    txsConfig.minDowntilt = str2double(hDowntilt.String);
    txsConfig.minTaper = str2double(hTaper.String);
    txsConfig.freq = str2double(hFreq.String);


    %max
    txsConfig.maxPower = str2double(hTxPowerMax.String);
    txsConfig.maxDowntilt = str2double(hDowntiltMax.String);
    txsConfig.maxTaper = str2double(hTaperMax.String);


    %Receiver params
    rxConfig.bw = str2double(hBw.String);  % 20 MHz bandwidth
    rxConfig.rxNoiseFigure = str2double(hNf.String);      % dB (typical UE)
    rxConfig.rxAntennaHeight = str2double(hRxAntHeight.String);  % meters (user equipment height)
    rxConfig.centerLat = str2double(hRxCenterLat.String);
    rxConfig.centerLon = str2double(hRxCenterLon.String);

    minVals = [txsConfig.minPower,  txsConfig.minDowntilt, txsConfig.minTaper];
    maxVals = [txsConfig.maxPower,  txsConfig.maxDowntilt, txsConfig.maxTaper];

    
    if any(isnan([rxConfig.bw, rxConfig.rxNoiseFigure, rxConfig.rxAntennaHeight, rxConfig.centerLat, rxConfig.centerLon]))
        errordlg('No Receiver Parameters detected.');
        return;
    end

    if any(isnan(minVals))
        errordlg('No Min Transmission Parameters detected.');
        return;
    end

    if any(isnan(maxVals))
        errordlg('No Max Transmission Parameters detected.');
        return;
    end

    if any(minVals > maxVals) 
        errordlg("Max parameters must be greater than min parameters!");
        return;
    end

    if(isnan(txsConfig.freq)) 
        errordlg("Insert frequency!");
        return;
    end

    generateSim(txsConfig, rxConfig);

end

function DocumentationButtonPushed(app, event)
    
    pdfName = 'documentation.pdf';
    
    
    appFolder = fileparts(mfilename('fullpath'));
    pdfPath = fullfile(appFolder, pdfName);
    
    
    if exist(pdfPath, 'file') == 2
        if ispc
            winopen(pdfPath); 
        else
            web(pdfPath, '-browser'); 
        end
    else
        errordlg(['Could not find ', pdfName, ' in the app folder!'], 'File Missing');
    end
end

end