% This function finds spike times, etc.
function [minTime,  maxTime, minV, maxV, t, V, dataSP, FalseSpikeT, ...
    burSPKtimes_medians, burSPKvolt_medians, ...
          idxLR_eachBurst, burstSpikes, burstSpikeTimes, burstspikesIndex] = ...
        prepareDataForSTA0(CTT, invertTriggeringTraceT, ...
            invertCorrectionTraceT, dataT, ISIburstT, TrefractoryT, ...
            threshT, peakT, sta_methodT, spike_subtractorT, spike_adderT)

%IntervalNegT, IntervalPosT, IntervalNegLocalT, IntervalPosLocalT,...

    %V = []; 
    V0 = [];
    %t = [];
    %dataSP = [];
    burSPKtimes_medians = [];
    burSPKvolt_medians = [];
    idxLR_eachBurst = [];
    
    if (CTT == 1);
          V0 = invertCorrectionTraceT * dataT(:,4);
          %CorrectionForSTA;
    end

     V = invertTriggeringTraceT * dataT(:,2);
     t = dataT(:,1);
%      st = size(dataT(:,1))
%      sv = size(dataT(:,2))
     minTime = min(t)
     maxTime = t(length(t))
     % maximum and minimum voltage
     maxV = 1.1 * max(V)
     minV = 1.1 * min(V)
     
     [spikeTime, spikeV, spikeNN, FalseSpikeT] = sta_2_spike_detector(t, ...
         TrefractoryT, threshT, peakT, CTT, V);
     
     %dataSP = zeros(length(spikeTime),3);
     dataSP = [spikeTime spikeV spikeNN];
     
     
               
     %xL = -IntervalNegT;
     %xR = IntervalPosT;
     %timestep = dataT(2,1)-dataT(1,1);

     %NPointsWinNeg = round(IntervalNegT/timestep);
     %NPointsWinPos = round(IntervalPosT/timestep);
     %NPointsWin = NPointsWinNeg + NPointsWinPos;

     %NPointsWinNegLocal = round(IntervalNegLocalT/timestep);
     %NPointsWinPosLocal = round(IntervalPosLocalT/timestep);

     %data = dataT(:,3);
     %len = length(data);
     NSpikes = length(dataSP)

     %ispike = dataSP(:,3);
     ISI = dataSP(2:NSpikes,1) - dataSP(1:NSpikes-1,1);%inter-spike intervals
     %disp('FOUND bursts...Note: These are the bursts inside - ie, the 1st and last bursts are disregarded!!!')
     nB = find(ISI >= ISIburstT) %+ 1; %Mike had here (+1) --- why???
     lennB = length(nB); % number of bursts
     if(lennB == 0)
          fprintf('No bursts\n');
          return;
     end
     
    [idxLR_eachBurst, burstSpikes, burstSpikeTimes, burstSpikeVoltages, burstspikesIndex] = ...
        getLRindicesEachBurst(nB, spikeNN, spikeTime, spikeV);
     
     if ~isempty(nB)
        if (sta_methodT == 2)||(sta_methodT == 0)
            %%% ??? why this dataSP with spikesNN and spikeTimes is not
            %%% returned??? -ADM
            %%% => SpikeTimes returned now. -CG
            [burSPKtimes_medians, burSPKvolt_medians, dataSPP] = ...
                sta_4_median_spike_finder(spike_subtractorT, ...
                    spike_adderT, burstSpikes, burstSpikeTimes, ...
                    burstSpikeVoltages);
            %NSpikesSPP = length(dataSPP)
        end
        %if sta_methodT == 0
          %nBI = nB(2:lennB) - nB(1:lennB-1);
          %size(nBI)
          %disp(sprintf('...The number of spikes in this burst is %d ',nBI))
%           sprintf('Total number of spikes is %d ',sum(nBI));
%           %MaxnBI = max(nBI)
%           MeannBI = floor(mean(nBI));
%           sprintf('The average number of spikes in each burst is %d ', MeannBI);
%           avg_period = (mean(diff(spikeTime(nB))));
%           sprintf('The average period is %.2f seconds \n ',avg_period);
          
        %end    
        
     else
         disp('Threshold and other globals for spike detection way off. Restart the program!!!!')
         return;
     end
     
end