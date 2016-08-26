function plotVoltageTracesLeft(tT, VT, x_labelT, DataNamesT,...
    minTimeT, maxTimeT, minVT, maxVT, threshT, peakT, tLeft, vLeft, ...
    FalseSpikeT, CTT, burSPKtimes_medT, burSPKvolt_medT)

    % now create a figure that plots the voltage trace, along with the detected
    % spikes and the lower and upper thresholds
    figure;
    plot(tT,VT);
    hold on;
    xlabel(x_labelT)
    ylabel(DataNamesT);
    axis([minTimeT maxTimeT minVT maxVT]);
    plot([minTimeT maxTimeT],[threshT threshT],'--g')
    plot([minTimeT maxTimeT],[peakT peakT], '--r')
    plot(tLeft,vLeft,'r+');
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


