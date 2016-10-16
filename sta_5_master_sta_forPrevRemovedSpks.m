%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               NOTHING TO BE CHANGED BELOW THIS LINE!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% DATA PREPARATION %%%%%%%%%%%%%%%%%%%%%%
% this line says that if you want to calculate the individual sta's, 
% use the spikeburstforindividualspikesta
function sta_5_master_sta_forPrevRemovedSpks(data, dataSpkRemoved, ...
    origFileName, nameHN)

%sta_1_global %load constants
choiceCT = 'Yes';

%%% remember yourself what globals you used previously when you removed the
%%% spikes
while strcmp(choiceCT, 'Yes')
%%% load constants
[sta_method, invertCorrectionTrace, invertTriggeringTrace, ...
NdiscardFirst, NdiscardLast, IntervalPosLocal, IntervalNegLocal, ...
IntervalPos, IntervalNeg, IntervalPos2, IntervalNeg2, IntervalPSCNeg, ...
ISIburst, thresh, peak, Trefractory, CorrectionTrace, CT, CalcMin, ...
spike_subtractor, spike_adder, Overlay, DataNames, x_label, yL, yH, ...
xlabel1, ylabel1, FntS, TracesPerPage, NBurstsStat, PrintNext] = ...
        askWinSTA_1_global(nameHN);
 
disp('************ in sta_5_masterSTA_forPrevRemovedSpks line 25 *****************')

choiceCT = questdlg('Do you want to revise the global data?',...
    'Global data', 'Yes', 'No','Yes');
end
   

%%% prepare data for plot of voltages; this is the initial data with all
%%% traces before any spike removal happen
[minTimeH,  maxTimeH, minVH, maxVH, tT, V, dataSP, FalseSpike, ...
    burSPKtimes_med, burSPKvolt_med, indexLR_ofBursts] = ...
        prepareDataForSTA0(CT, invertTriggeringTrace, ...
            invertCorrectionTrace, data, ISIburst, Trefractory, thresh, ...
            peak, sta_method, spike_subtractor, spike_adder);

        
%%% now create a figure that plots the voltage trace, along with the 
%%% detected spikes and the lower and upper thresholds
plotVoltageTraces(tT, V, x_label, DataNames, minTimeH, maxTimeH, ...
       minVH, maxVH, thresh, peak, dataSP(:,3), ...
       burSPKtimes_med, burSPKvolt_med); %FalseSpike, CT, ...

disp('***** STA 5 ***********')
tT(1:20)
V(1:20)
dataSP(1:20,:)
disp('....in STA 5...size of dataSP')
size(dataSP)   %%% 637 - bursts and spikes recognized from original file

%%% filter the initial data (remove traces) according to the remaining
%%% spikes after the removal took place
%%% tT %%% original times of traces
%%% V %%% original voltages
%%% dataSP %%% [times voltages spikes] - processed and ready for removal

[new_tT, new_V, new_dataSP, new_data] = getFilteredData(tT, V, ...
    dataSP, dataSpkRemoved, data); 
disp('....in STA 5...size of new_dataSP ... after removal of spikes')
size(new_dataSP)
disp('....in STA 5...size of new_data ... after removal of spikes')
size(new_data)

%%%%%%%%% TO DO

%%% prepare new data for plot of voltages; this is the initial data with 
%%% all traces (still remaining) before any spike removal happen 
[minTimeH,  maxTimeH, minVH, maxVH, dataSP,  ...
    burSPKtimes_med, burSPKvolt_med, indexLR_ofBursts] = ...
        prepareNewDataForSTA0(CT, new_data, ISIburst, Trefractory, thresh, ...
            peak, sta_method, spike_subtractor, spike_adder, ...
            new_dataSP, invertTriggeringTrace);
        
%%% now create a figure that plots the new (ramaining) voltage trace, along with the 
%%% detected spikes and the lower and upper thresholds
plotVoltageTraces(tT, V, x_label, DataNames, minTimeH, maxTimeH, ...
       minVH, maxVH, thresh, peak, new_dataSP(:,3), ...
       burSPKtimes_med, burSPKvolt_med); %FalseSpike, CT,...





%close all    

disp('******* GLOBAL DATA USED in STA_5 for previously removed spikes **********')
displayGlobalDataUsed(sta_method, invertCorrectionTrace, ...
    invertTriggeringTrace, NdiscardFirst, NdiscardLast, IntervalPosLocal, ...
    IntervalNegLocal, IntervalPos, IntervalNeg, IntervalPos2, ...
    IntervalNeg2, IntervalPSCNeg, ISIburst, thresh, peak, Trefractory, ...
    CorrectionTrace, CT, CalcMin, spike_subtractor, spike_adder, Overlay, ...
    DataNames, x_label, yL, yH, xlabel1, ylabel1, FntS, TracesPerPage, ...
    NBurstsStat, PrintNext);
disp('***********************************')

sta_method
disp('************ in sta_5_masterSTA line 75 *****************')
if sta_method == 0             %%% global sta
    performSTA_0_spikeRemoval(CT, invertCorrectionTrace, ...
        data, dataSP, IntervalNeg2, IntervalPos2, ISIburst, IntervalPSCNeg, ...
        indexLR_ofBursts, origFileName, nameHN, sta_method, CalcMin, ...
        xlabel1, ylabel1, tT, V, x_label, DataNames, minTimeH, maxTimeH, ...
        minVH, maxVH, thresh, peak, FalseSpike, burSPKtimes_med, ...
        burSPKvolt_med, FntS, IntervalPosLocal, IntervalNegLocal);
end

disp('************ in sta_5_masterSTA line 85 *****************')
if sta_method == 1
    %%% for Mike's plots uncomment the following lines %%%%%%%%%%%%%%
    [NN, wint, winF, goodSpF, NPointsWinPSCNeg] = ...
        sta_3_individual_sta(CT, invertTriggeringTrace, ...
            invertCorrectionTrace, data, IntervalNeg2, IntervalPos2, ...
            ISIburst, Trefractory, thresh, peak, IntervalPSCNeg, ...
            NBurstsStat);
        
    [MaxNum, MinNum, Max, Min, DifSyn] = calcAmplBiggestEvent(NN, ...
        winF, NPointsWinPSCNeg);
    
    plotIPSCtracesPerPage(NN, TracesPerPage, PrintNext, FntS, ...
        IntervalNeg2, IntervalPos2, wint, winF, Max, Min, MaxNum, ...
        MinNum, goodSpF);

    plotMaxIPSCvsNoSpikes(DifSyn);
    %% end Mike's plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

if  (sta_method == 2) % || (sta_method == 0) Means you could have input a 0 or 2
   
    [dataH, len, NSpikes, xL, xR, timestep, NPointsWinNeg, ...
    NPointsWinPos, NPointsWin, NPointsWinNegLocal, NPointsWinPosLocal,...
    ispike, nB, lennB, minTimeH,  maxTimeH, minVH, maxVH, ...
    tT, V, spikeNNH, FalseSpike, burSPKtimes_med, ...
    burSPKvolt_med] = prepareData(CT, invertTriggeringTrace, ...
        invertCorrectionTrace, data, IntervalNeg, IntervalPos, ...
        IntervalNegLocal, IntervalPosLocal, ISIburst, Trefractory, thresh,...
        peak, sta_method, spike_subtractor, spike_adder);

    %% now create a figure that plots the voltage trace, along with the detected
    %% spikes and the lower and upper thresholds
    plotVoltageTraces(tT, V, x_label, DataNames, minTimeH, maxTimeH, ...
        minVH, maxVH, thresh, peak, spikeNNH, FalseSpike, CT,...
        burSPKtimes_med, burSPKvolt_med)
    
  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% DATA ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%% Works for sta_method of 0 or 2
    if sta_method == 2;
        disp((sprintf('There are %d spikes in this record \n', NSpikes)))
        NdiscardFirst = 0;
        NdiscardLast = 0;
    end
disp('************ in sta_5_masterSTA line 121 *****************')

    nbadSpikes = getBadSpk(lennB, nB, NdiscardFirst, NSpikes);

    [goodSp, wint, win] = getGoodSpikes(NSpikes, NdiscardLast, ...
        nbadSpikes, ispike, NPointsWinNeg, NPointsWinPos, dataH, ...
        Overlay, timestep, NPointsWin, len);
    win = win / goodSp;
    %      HNMean=mean(win')';
    %      minY=min(min(win));
    %      maxY=max(max(win));
    if goodSp;
        plotSpkTrigAvg(wint, win, NPointsWinNegLocal, NPointsWinPosLocal, ...
            CalcMin, xR, yH, goodSp, xL, yL, xlabel1, ylabel1, ...
            origFileName, sta_method) 
    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


