function [minTime,  maxTime, minV, maxV, dataSP,  ...
    burSPKtimes_medians, burSPKvolt_medians, idxLR_eachBurst] = ...
        prepareNewDataForSTA0(CTT, dataT, ISIburstT, TrefractoryT, ...
            threshT, peakT, sta_methodT, spike_subtractorT, ...
            spike_adderT, idxNewSpikes, invertTriggeringTraceT)

%IntervalNegT, IntervalPosT, IntervalNegLocalT, IntervalPosLocalT,...
% FalseSpikeT

disp('********** in prepareNewDataForSTA0 **********')
    %V = []; 
    %t = [];
    %dataSP = [];
    burSPKtimes_medians = [];
    burSPKvolt_medians = [];
    idxLR_eachBurst = [];
   
    %%% no correction need it since this has been done before
%     if (CTT == 1);
%           V0 = invertCorrectionTraceT * dataT(:,4);
%           %CorrectionForSTA;
%     end

     %%% no correction need it since this has been done before
     %V = invertTriggeringTraceT * dataT(:,2);
     V = invertTriggeringTraceT * dataT(:,2);
     t = dataT(:,1);
%      st = size(dataT(:,1))
%      sv = size(dataT(:,2))
     minTime = min(t)
     maxTime = t(length(t))
     % maximum and minimum voltage
%      maxV = 1.1 * max(V)
%      minV = 1.1 * min(V)
      maxV = max(V)
      minV = min(V)

     disp('....in prepNewDataForSTA0...size of input data ... after removal of spikes')
     size(dataT)
     size(idxNewSpikes)
     
     %%% ???? we don't really need this step, since the spikes are OK due
     %%% to previous analysis and removal.
%      [spikeTime, spikeV, spikeNN, FalseSpikeT] = sta_2_spike_detector(t, ...
%          TrefractoryT, threshT, peakT, CTT, V);


     [rdt, cdt] = size(dataT)
     spikeTime = zeros(rdt,1);
     spikeV = zeros(rdt,1);
     spikeNN = zeros(rdt,1);
     for ii = 1:rdt
         spikeTime(ii) = dataT(ii,1);
         spikeV(ii) = dataT(ii,2);
         spikeNN(ii) = idxNewSpikes(ii); %%% if CTT = 1 then this needs to be taken from original voltage file
     end
     
     
     disp('...checking times...')
     t(1:10)
     spikeTime(1:10)
     disp('...checking voltages...')
     V(1:10)
     spikeV(1:10)
     disp('...checking spikes indices...')
     dataT(1:10)
     spikeNN(1:10)
     
     %dataSP = zeros(length(spikeTime),3);
     dataSP = [spikeTime spikeV spikeNN];
     
     disp('....in prepNewDataForSTA0....line 69....size of data ... after STA_2....')
%      disp('size of spikeTime: ')
%      size(spikeTime)
%      disp('size of spikeV: ')
%      size(spikeV)
%      disp('size of spikeNN: ')
%      size(spikeNN)
%              
%      disp('size of this dataSP (here) on line 53: ')
%      size(dataSP)
     
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
     
    [idxLR_eachBurst, burstSpikes, burstSpikeTimes, burstSpikeVoltages] = ...
        getLRindicesEachBurst(nB, spikeNN, spikeTime, spikeV);
     
     if ~isempty(nB)
        if (sta_methodT == 2)||(sta_methodT == 0)
            %%% ??? why this dataSP with spikesNN and spikeTimes is not
            %%% returned???
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