function [idxL, idxR] = plotSpkTrigAvgCloud(winT, traces, fileName, sta_methodT, ...
    CalcMinT, xlabel1T, ylabel1T,  avgTr, stdTrT, goodSp, NPointsWinNegLocalT, ...
    maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, maxNegIPSC, maxNegIPSCNN, ...
    maxPosIPSC, maxPosIPSCNN, minNegIPSC, minNegIPSCNN, minPosIPSC, ...
    minPosIPSCNN, IntervalNeg2T, IntervalPos2T, nameHNsig, period, ...
    numRemSpks, ampLSTD, ampRSTD, avgAmpL, avgAmpR, stdAmpL, stdAmpR)

nameHNsig
str0 = [];
[aux1, aux2] = strtok(fileName,'_');
aux3 = strtok(aux2, '_');
str0{1} = ['File: ' aux1 '\_' aux3];
str0{2} = ['HN signal: ' nameHNsig];

str = [];
str{1} = [];
str{2} = [];
if CalcMinT == 0
        str{1} = ['AmpL = ' num2str(maxIPSC - minNegIPSC)];
        str{2} = ['AmpR = ' num2str(maxIPSC - minPosIPSC)];
%         str{3} = ['Maximum at ' num2str(winT(maxIPSCNN))];
%         str{4} = ['# of Spikes used = ' num2str(goodSp)];
else
        str{1} = ['AmpR= ' num2str(maxPosIPSC - minIPSC)];        
        str{2} = ['AmpL= ' num2str(maxNegIPSC - minIPSC)];              
end
%str{3} = ['Maximum at ' num2str(winT(minIPSCNN))]; 
str{3} = ['Maximum at ' num2str(winT(maxIPSCNN))]; 
str{4} = ['# of Spikes used = ' num2str(goodSp)]; 
str{5} = ['# of Removed spikes = ' num2str(numRemSpks)];
str{6} = ['Average period = ' num2str(period)];

str{7} = ['AmpLSTD = ' num2str(ampLSTD)];
str{8} = ['AmpRSTD = ' num2str(ampRSTD)];
str{9} = '';
str{10} = '';

%%% fig 1: cloud 
showFig_Cloud('SpkTrigAvg Cloud', sta_methodT, traces, winT, ...
    IntervalNeg2T, IntervalPos2T, str0, str, xlabel1T, ylabel1T);

%%% fig 2: cloud and avg
showFig_CloudAvg('SpkTrigAvg Cloud_Avg', sta_methodT, traces, winT, avgTr, ...
    NPointsWinNegLocalT, maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, ...
    maxNegIPSC, maxNegIPSCNN, maxPosIPSC, maxPosIPSCNN, minNegIPSC, ...
    minNegIPSCNN, minPosIPSC, minPosIPSCNN, IntervalNeg2T, IntervalPos2T, ...
    CalcMinT, str0, str, xlabel1T, ylabel1T);

%%% fig 3: cloud, avg and sd (sd = 1/n*sum(...))
[idxL, idxR] = showFig_CloudAvgSD('SpkTrigAvg Cloud_Avg_Std', sta_methodT, traces, winT, avgTr, ...
    stdTrT, NPointsWinNegLocalT, maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, ...
    maxNegIPSC, maxNegIPSCNN, maxPosIPSC, maxPosIPSCNN, minNegIPSC, ...
    minNegIPSCNN, minPosIPSC, minPosIPSCNN, IntervalNeg2T, IntervalPos2T, ...
    CalcMinT, str0, str, xlabel1T, ylabel1T, ...
    avgAmpL, avgAmpR, stdAmpL, stdAmpR);

%%% fig 4: avg
showFig_Avg('SpkTrigAvg Avg', winT, avgTr, NPointsWinNegLocalT, maxIPSC, ...
    maxIPSCNN, minIPSC, minIPSCNN, maxNegIPSC, maxNegIPSCNN, maxPosIPSC, ...
    maxPosIPSCNN, minNegIPSC, minNegIPSCNN, minPosIPSC, minPosIPSCNN, ...
    IntervalNeg2T, IntervalPos2T, CalcMinT, str0, str, xlabel1T, ylabel1T, ...
    nameHNsig);

%%% fig 5: avg and sd (sd = 1/n*sum(...))
showFig_AvgSD('SpkTrigAvg Avg_Std', winT, avgTr, stdTrT, NPointsWinNegLocalT, ...
    maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, maxNegIPSC, maxNegIPSCNN, ...
    maxPosIPSC, maxPosIPSCNN, minNegIPSC, minNegIPSCNN, minPosIPSC, ...
    minPosIPSCNN, IntervalNeg2T, IntervalPos2T, CalcMinT, str0, str, ...
    xlabel1T, ylabel1T, nameHNsig);


hh = helpdlg('Press OK if done with the plots for this signal','Done');
uiwait(hh);
close all;

%%% end fig 2
 end