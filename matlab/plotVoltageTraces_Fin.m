function plotVoltageTraces_Fin(tT, VT, x_labelT, DataNamesT,...
    minTimeT, maxTimeT, minVT, maxVT, threshT, peakT, spikeNNT, ...
    FalseSpikeT, CTT, burSPKtimes_medT, burSPKvolt_medT, fileName)


    aux = dlmread(fileName, '\t');
    origSpks = aux(:,1);
    leftSpks = aux(:,2);
    
    figure;
    plot(tT,VT);
    hold on;
    xlabel(x_labelT)
    ylabel(DataNamesT);
    axis([minTimeT maxTimeT minVT maxVT]);
    plot([minTimeT maxTimeT],[threshT threshT],'--g')
    plot([minTimeT maxTimeT],[peakT peakT], '--r')
    plot(tT(spikeNNT),VT(spikeNNT),'r+');
    
    spkMax = max(VT) + 30;
    for jj = 1:length(origSpks)
        if (leftSpks(jj,1) == 1) %% kept spike
            plot(origSpks(jj,1),[spkMax spkMax],'r+')
        else % removed spike
            plot(origSpks(jj,1),[spkMax spkMax],'k+')
        end
    end
    
    if CTT == 1
       plot(tT(FalseSpikeT),VT(FalseSpikeT),'kv');
    end

    % this last set of the code plots the median spikes that are determined
    % over the first figure (1) from sta_2_spike_detector. 
    for ii = 1:length(burSPKtimes_medT)
         plot(burSPKtimes_medT{ii}, burSPKvolt_medT{ii}, 'kd')
         axis([minTimeT maxTimeT minVT maxVT]);
    end


end


% if sta_methodT ~= 2
%      plot(tT,VT);
%      hold on;
%      xlabel(x_labelT)
%      ylabel(DataNamesT);
%      axis([minTimeT maxTimeT minVT maxVT]);
%      plot([minTimeT maxTimeT],[threshT threshT],'--g')
%      plot([minTimeT maxTimeT],[peakT peakT], '--r')
%      plot(tT(spikeNNT),VT(spikeNNT),'r+');
%      if CTT==1
%           plot(tT(FalseSpikeT),VT(FalseSpikeT),'kv');
%      end
% else
%      plot(tT,VT);
%      hold on;
%      xlabel(x_labelT)
%      ylabel(DataNamesT);
%      axis([minTimeT maxTimeT minVT maxVT]);
%      plot([minTimeT maxTimeT],[threshT threshT],'--g')
%      plot([minTimeT maxTimeT],[peakT peakT], '--r')
%      plot(tT(spikeNNT),VT(spikeNNT),'r+');
%      if CTT==1
%           plot(tT(FalseSpikeT),VT(FalseSpikeT),'kv');
%      end
% end