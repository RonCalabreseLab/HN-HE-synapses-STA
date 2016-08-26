function [restBurstSpikes, idxRemovedSpks] = ...
    deleteBurstSpikes(indexREFburst, spkToRemBurst)

idxRemovedSpks = zeros(length(spkToRemBurst),1);
disp(['spikes to delete = ' mat2str(spkToRemBurst)])
for i = 1:length(spkToRemBurst)
   idxRemovedSpks(i,1) = indexREFburst(spkToRemBurst(i));
   indexREFburst(spkToRemBurst(i)) = 0;
end

%indexREFburst
restBurstSpikes = indexREFburst(find(indexREFburst > 0));
disp(['index spikes to delete = ' mat2str(idxRemovedSpks)])
end