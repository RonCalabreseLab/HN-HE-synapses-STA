function [indexLR_eachBurst, burstspikes, burstspiketimes, ...
    burstspikevoltages, burstspikesIndex] = getLRindicesEachBurst(nBT, spikeNNT, ...
    spikeTimeT, spikeVT)

indexLR_eachBurst = cell(1, length(nBT) + 1);
burstspikes = cell(1, length(nBT) + 1);
burstspikesIndex = repmat(NaN, length(nBT) + 1, 2);
burstspiketimes = cell(1, length(nBT) + 1);
burstspikevoltages = cell(1, length(nBT) + 1);

% commented out by CG by adding if statement to loop below
% $$$ % i initialized these three variables as cell arrays. i had to do this
% $$$ % because each burst has a different number of spikes in it.
% $$$ vv = spikeTimeT(1:nBT(1));
% $$$ disp(['...burst ' num2str(1) '...' mat2str(vv)])
% $$$ disp(['noSpikes = ' num2str(length(vv))])
% $$$ vv = spikeNNT(1:nBT(1));
% $$$ disp([' indices = ' mat2str(vv)])
% $$$ aux = [vv(1) vv(end)]; 
% $$$ indexLR_eachBurst{1} = aux;
% $$$ burstspikes{1} = spikeNNT(1:nBT(1));
% $$$ burstspiketimes{1} = spikeTimeT(1:nBT(1));
% $$$ burstspikevoltages{1} = spikeVT(1:nBT(1));

% this first for loop segregates out the spikes into bursts. i do the same
% for the spiketimes and spike voltages, because these are what will be
% passed back to the first script for analysis.
burst_num = 0;
min_burst_spikes = 3;
for ii=0:length(nBT)
  if ii == 0
    burst_start = 1;
  else
    burst_start=nBT(ii) + 1;
  end
     if ii == length(nBT)
       burst_end = length(spikeNNT);
     else
       burst_end=nBT(ii+1);
     end
     % only allow bursts with enough spikes
     if (burst_end - burst_start + 1) < min_burst_spikes; 
       disp(['Skipping burst ' num2str(ii) ' with ' ...
             num2str(burst_end - burst_start  +1) ' spikes (Minimum is ' ...
             num2str(min_burst_spikes) ' spikes).'])
       continue;
     end
     burst_num = burst_num + 1;
     vv = spikeTimeT(burst_start:burst_end);
     disp(['...burst ' num2str(burst_num) '...' mat2str(vv)])
     disp(['noSpikes = ' num2str(length(vv))])
     vv = spikeNNT(burst_start:burst_end);
     %disp([' indices = ' mat2str(vv)])
     aux = [vv(1) vv(end)];
     indexLR_eachBurst{burst_num} = aux;
     burstspikesIndex(burst_num, :) = [burst_start, burst_end];
     burstspikes{burst_num} = spikeNNT(burst_start:burst_end);
     burstspiketimes{burst_num} = spikeTimeT(burst_start:burst_end);
     burstspikevoltages{burst_num} = spikeVT(burst_start:burst_end);
end

% Commented-out by CG by adding if statement into loop above
% $$$ % this needed to be added to ensure that i got all of the bursts. for the
% $$$ % non-programming oriented, you will see that the length of nBT is 10, which
% $$$ % means that there are length(nBT)+1 bursts (ie, 11) in the file. when i executed the
% $$$ % for loop above, you can see that there are nine intervals between the 10
% $$$ % bursts. i already initialized the cell array with {1} in lines 20 through
% $$$ % 22. so, in order to get the last burst, i took the last index ii (9) and
% $$$ % added 2 to it so i could get the last burst.
% $$$ vv = spikeTimeT((nBT(end)+1):length(spikeNNT));
% $$$ disp(['...burst ' num2str(ii + 2) '...' mat2str(vv)])
% $$$ disp(['noSpikes = ' num2str(length(vv))])
% $$$ vv = spikeNNT((nBT(end)+1):length(spikeNNT));
% $$$ disp([' indices = ' mat2str(vv)])
% $$$ aux = [vv(1) vv(end)];
% $$$ indexLR_eachBurst{ii+2} = aux;
% $$$ burstspikes{ii+2} = spikeNNT((nBT(end)+1):length(spikeNNT));
% $$$ burstspiketimes{ii+2} = spikeTimeT((nBT(end)+1):length(spikeNNT));
% $$$ burstspikevoltages{ii+2} = spikeVT((nBT(end)+1):length(spikeNNT));

% truncate rest of cells
indexLR_eachBurst = indexLR_eachBurst(1:burst_num);
burstspikes = burstspikes(1:burst_num);
burstspiketimes = burstspiketimes(1:burst_num);
burstspikevoltages = burstspikevoltages(1:burst_num);
burstspikesIndex = burstspikesIndex(1:burst_num, :);

% display indices
for j = 1:length(indexLR_eachBurst)
   aa = indexLR_eachBurst{j};
   disp([' burst ' num2str(j) ' index first spike = ' num2str(aa(1)) ...
       ' index last spike = ' num2str(aa(2))])
end

end
