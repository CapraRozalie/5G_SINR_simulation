function ControlGui()
height = 300;
width = 420;

f = figure('Position',[300 500 width height],'Name','TxSite Control');

towerList = [];

dy = 40; 
y = height - dy;

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

% Tower list display
hList = uicontrol(f,'Style','listbox',...
    'Position',[20 y-40 350 80],...
    'String',{});

% SINR checkbox
hSINR = uicontrol(f,'Style','checkbox',...
    'Position',[20 30 150 25],'String','Show SINR');

% Run button
uicontrol(f,'Style','pushbutton',...
    'Position',[250 30 120 30],...
    'String','Generate Map',...
    'Callback',@runSimulation);

    function addArrElement(~,~)

    lat = str2double(hLat.String);
    lon = str2double(hLong.String);
    h   = str2double(hHeight.String);

    if isnan(lat) || isnan(lon) || isnan(h)
        errordlg('Invalid input values');
        return;
    end

    towerList(end+1,:) = [lat lon h];

    % Build display list
    listStr = cell(size(towerList,1),1);

    for i = 1:size(towerList,1)
        listStr{i} = sprintf('Lat: %.6f | Lon: %.6f | H: %.2f', ...
            towerList(i,1), towerList(i,2), towerList(i,3));
    end

    % Update GUI
    set(hList, 'String', listStr);

    drawnow;

    % Clear inputs
    hLat.String = '';
    hLong.String = '';

    end

function runSimulation(~,~)

    if isempty(towerList)
        errordlg('No towers added!');
        return;
    end

    txsConfig.towers = towerList;
    txsConfig.showSINR = hSINR.Value;
    txsConfig.numTowers = size(towerList,1);

    rxConfig.bw = 20e6;              % 20 MHz bandwidth
    rxConfig.rxNoiseFigure = 7;      % dB (typical UE)
    rxConfig.rxAntennaHeight = 1.5;  % meters (user equipment height)
    rxConfig.minLat=10;
    rxConfig.maxLat=20;
    rxConfig.minLon=10; 
    rxConfig.maxLon=20;

    myMap(txsConfig,rxConfig, workFq);

end

end