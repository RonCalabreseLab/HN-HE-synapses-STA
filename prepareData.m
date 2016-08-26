function [data, len, NSpikes, xL, xR, timestep, NPointsWinNeg, ...
    NPointsWinPos, NPointsWin, NPointsWinNegLocal, NPointsWinPosLocal,...
    ispike, nB, lennB,  minTime,  maxTime, minV, maxV, t, V, ...
    spikeNN, FalseSpikeT, burSPKtimes_medians, ...
    burSPKvolt_medians] = prepareData(CTT, invertTriggeringTraceT, ...
        invertCorrectionTraceT, dataT, IntervalNegT, IntervalPosT, ...
        IntervalNegLocalT, IntervalPosLocalT, ISIburstT, TrefractoryT, ...
        threshT, peakT, sta_methodT, spike_subtractorT, spike_adderT)

    V = []; V0 = [];
    t = [];
    dataSP = [];
    burSPKtimes_medians = [];
    burSPKvolt_medians = [];
    
    if (CTT == 1);
          V0 = invertCorrectionTraceT * dataT(:,4);
          %CorrectionForSTA;
    end

     V = invertTriggeringTraceT * dataT(:,2);
     t = dataT(:,1);
     minTime = min(t);
     maxTime = t(length(t));
     % maximum and minimum voltage
     maxV = 1.1 * max(V);
     minV = 1.1 * min(V);
     
     [spikeTime, spikeV, spikeNN, FalseSpikeT] = sta_2_spike_detector(t, ...
         TrefractoryT, threshT, peakT, CTT, V);
     
   

     dataSP = zeros(length(spikeTime),3);
     dataSP = [spikeTime spikeV spikeNN];
          
     xL = -IntervalNegT;
     xR = IntervalPosT;
     timestep = dataT(2,1)-dataT(1,1);

     NPointsWinNeg = round(IntervalNegT/timestep);
     NPointsWinPos = round(IntervalPosT/timestep);
     NPointsWin = NPointsWinNeg + NPointsWinPos;

     NPointsWinNegLocal = round(IntervalNegLocalT/timestep);
     NPointsWinPosLocal = round(IntervalPosLocalT/timestep);

     data = dataT(:,3);
     len = length(data);
     NSpikes = length(dataSP);

     ispike = dataSP(:,3);
     ISI = dataSP(2:NSpikes,1) - dataSP(1:NSpikes-1,1);
     nB = find(ISI >= ISIburstT)+1;
     lennB = length(nB);
     %      if(lennB==0)
     %           fprintf('No bursts\n');
     %           break;
     %      end
     
     if sta_methodT == 2
        [burSPKtimes_medians, burSPKvolt_medians, dataSP] = ...
            sta_4_median_spike_finder(spike_subtractorT, spike_adderT, ...
            spikeNN, nB, spikeTime, spikeV);
        NSpikes = length(dataSP);
     end
     if sta_methodT == 0
          nBI = nB(2:lennB) - nB(1:lennB-1);
          disp(sprintf('The number of spikes in this burst is %d \n',nBI))
          MaxnBI = max(nBI);
          MeannBI = floor(mean(nBI));
          disp((sprintf('The average number of spikes in each burst is %d \n', MeannBI)))
          avg_period = (mean(diff(spikeTime(nB))));
          disp(sprintf('The average period is %.2f seconds \n',avg_period))
          if(lennB == 0)
               fprintf('No bursts\n');
               %return;
          end 
     end    
     
end