function [avgTrT, stdT, goodSpT, timestepT, NPointsWinNegLocalT, ...
    maxIPSCT, maxIPSCNNT, minIPSCT, minIPSCNNT, maxNegIPSCT, ...
    maxNegIPSCNNT, maxPosIPSCT, maxPosIPSCNNT, minNegIPSCT, ...
    minNegIPSCNNT, minPosIPSCT, minPosIPSCNNT , ...
    ampL, ampR, avgAmpL, avgAmpR, stdAmpL, stdAmpR] = getDataForPlotAvgCloud(traces, ...
            winT, IntervalNegLocalT, IntervalPosLocalT, fileName)

avgTrT = 0;
goodSpT = 0;
stdT = 0;
row = 0;

%%% make it this way
% for ii = 1: length(traces)
%    avgTrT = avgTrT + sum(traces{ii},2);
%    [row, col] = size(traces{ii});
%    goodSpT = goodSpT + col; 
% end
% avgTrT = (avgTrT./goodSpT);
% stdMat = zeros(row,goodSpT);

%%% or make it this way - anyway same result
stdMat = [];
kk = 1;
for ii = 1: length(traces)
    zz = traces{ii};
    [~, col] = size(traces{ii});
    for jj=1:col
        stdMat(:,kk) = zz(:,jj);
        kk = kk + 1;
    end
end

goodSpT = kk - 1
stdT = std(stdMat,1,2);  %%% std = 1/n(...), so flag = 1
avgTrT = mean(stdMat,2);
%avgTrT = avg1;

%goodSp

%size(avgTr)
disp(['avg = ' mat2str(avgTrT)])
%disp(['avg now    = ' mat2str(avg1)])
disp(['std = ' mat2str(stdT)])

disp('... getDataForPlotAvgCloud ...') 
%stdT
timestepT = winT(2,1) - winT(1,1);
NPointsWinNegLocalT = round(IntervalNegLocalT/timestepT)
NPointsWinPosLocalT = round(IntervalPosLocalT/timestepT)

[maxIPSCT maxIPSCNNT] = max(avgTrT)
[minIPSCT minIPSCNNT] = min(avgTrT)
 
if (minIPSCNNT - NPointsWinNegLocalT > 0)
    [maxNegIPSCT maxNegIPSCNNT] = max(avgTrT(minIPSCNNT - ...
        NPointsWinNegLocalT:minIPSCNNT))
else
    [maxNegIPSCT maxNegIPSCNNT] = max(avgTrT(1:minIPSCNNT))
end
     
if(minIPSCNNT + NPointsWinPosLocalT) > length(avgTrT)
     [maxPosIPSCT maxPosIPSCNNT] = max(avgTrT(minIPSCNNT:end))
else
     [maxPosIPSCT maxPosIPSCNNT] = max(avgTrT(minIPSCNNT:minIPSCNNT + ...
         NPointsWinPosLocalT))
end
     
if (maxIPSCNNT - NPointsWinNegLocalT > 0)
    [minNegIPSCT minNegIPSCNNT] = min(avgTrT(maxIPSCNNT - ...
        NPointsWinNegLocalT:maxIPSCNNT))
else
    [minNegIPSCT minNegIPSCNNT] = min(avgTrT(1:maxIPSCNNT))
end

if ((maxIPSCNNT + NPointsWinPosLocalT) > length(avgTrT))
    [minPosIPSCT minPosIPSCNNT] = min(avgTrT(maxIPSCNNT:end))
else
    [minPosIPSCT minPosIPSCNNT] = min(avgTrT(maxIPSCNNT:maxIPSCNNT + ...
        NPointsWinPosLocalT))
end

%%%%%%%%%%% Cengiz's STDs

% Calculate STDs before averaging, on the amplitude differences 
% in each individual trace
ampL = repmat(NaN, 1, goodSpT);
ampR = repmat(NaN, 1, goodSpT);
kk = 1;

for ii = 1: length(traces)
    numCols = size(traces{ii}, 2);
    % two rows: ampL and ampR
    ampL(kk:(kk+numCols-1)) = ...
        diff(traces{ii}([minNegIPSCNNT; maxIPSCNNT], :));
    ampR(kk:(kk+numCols-1)) = ...
        diff(traces{ii}([minPosIPSCNNT; maxIPSCNNT], :));
    kk = kk + numCols;
end

avgAmpL = mean(ampL)
avgAmpR = mean(ampR)

stdAmpL = std(ampL)
stdAmpR = std(ampR)

%%%%%%%%%%% end of Cengiz's STDs

%%% these are really not useful !!!
% xLT = -IntervalNegT;
% xRT = IntervalPosT;
%yLT
%yHT

end