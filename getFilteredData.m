
%%% filters the traces, times, voltages and spikes according to the
%%% remaining spikes from the file, after spike removal was performed; it
%%% will work with the latest file of spikes (ie several spike removal
%%% sessions will overrride the file)

%%% dataSpkRem is the file read in containing the removed spikes (0) and
%%% the to be kept spikes (1); this file returns only the kept spikes 
%%% according to this file!!!

function [newT, newV, newDataSP, newData] = getFilteredData(tt, vv, ...
    datasp, dataSpkRem, dt)

format longG;
disp('------------ in getFilteredData -----------')
% keep only the left spikes (1) -  remove the removed spikes (0)
idx = find(dataSpkRem(:,2));
% idx(1:10)
[rr, ~] = size(idx)
[rtt,~] = size(tt);
ttt = zeros(rtt,1);
for kk = 1:rtt
    x = tt(kk,1);
    y = sprintf('%.5f',x);
    ttt(kk,1) = str2double(y);
end
% size(ttt)
% ttt(1:10)


idxAUX = 0;
newT = dataSpkRem(idx,1);    % time
% newT(1:10)
newV = zeros(rr,1); % voltage of HN spike
idxSPK = zeros(rr,1); % indices of spikes in the initial traces
%newDataSP = zeros(rr,3); % [ spkTime spkVoltage idxSpkInitTraces]
% [time traceHN traceHE] traces are the voltages; these data come from the initial file
%newData = zeros(rr,3); 
trHE = zeros(rr,1);

disp('....input datasp_1_10 in getFilteredData....')
datasp(1:10,:)
dt(1:10,:)

% disp('... dataSP rounding...')
[rsp,~] = size(datasp);
tsp = zeros(rsp,1);
for kk = 1:rsp
    x = datasp(kk,1);
    y = sprintf('%.5f',x);
    tsp(kk,1) = str2double(y);
end
% size(tsp)
% tsp(1:10)

% disp('... data (dt) rounding...')
[rdt,~] = size(dt);
tdt = zeros(rdt,1);
for kk = 1:rdt
    x = dt(kk,1);
    y = sprintf('%.5f',x);
    tdt(kk,1) = str2double(y);
end
% size(tdt)
% tdt(1:10)

for ii = 1:rr
  
    aux = newT(ii,1); %%% this is crazzy - when writing data to file, 
    %%% it got round to 5 decimals, but in the original file we have 6 
    %%% decimals precision; more crazzy the round fct doesn't work (why???)
    %%% so we do manual rounding to 5 decimals to fix the problems
    auxx = sprintf('%.5f',aux);
    aux = str2double(auxx);
    idxAUX = find(ttt == aux); % got the voltage
    newV(ii,1) = vv(idxAUX);
    
    idxAUX = find(tsp(:,1) == aux); % get the index of spike
    idxSPK(ii,1) = datasp(idxAUX,3);
    
    idxAUX = find(tdt(:,1) == aux); % get the HE voltage for this spike
    trHE(ii, 1) = dt(idxAUX,3);
end

newDataSP = [newT newV idxSPK]; 
newData = [newT newV trHE];

disp('....output datasp_1_10 from getFilteredData....')
newDataSP(1:10,:)
newData(1:10,:)

disp('----DONE-------- in getFilteresData -----------')
end