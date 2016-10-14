% Terrence Michael Wright, Jr. 9-10-2008
% sta_4_median_spike_finder. this script will generate the individual spike 
% triggered average(sta) analysis of certain spikes within a burst.
% I made this program to allow angela to determine the sta
% of a few spikes surrounding the middle spike of a burst. the idea is that
% we want to be able to generate a sta at a point in the burst in which the
% modulation (either facilitation or depression; see Wallace and Nichols,
% 1978, more recently Norris et al J Neurophysiol 2007) does not affect the
% measured sta. This file takes as its inputs the output from
% SpikeTriggeredAveragesSTA, and then segregates the spiketimes,
% spikevoltages and spikes themselves into discrete bursts. The script then
% passes these values back to the master sta script in order to generate
% the appropriate sta trace

function [burst_spiketimes_medians, burst_spikevoltages_medians,...
    dataSP] = sta_4_median_spike_finder(spike_subtractorT, spike_adderT, ...
        burstspikes, burstspiketimes, burstspikevoltages)

disp('............. in STA 4 .............')
spike_subtractor = spike_subtractorT
spike_adder = spike_adderT

disp('*** burstspiketimes ')
size(burstspiketimes)

disp('*** burstspikes ')
size(burstspikes)
% create a variable that corresponds to the last spiketime
%end_spike = length(spikeNNT);


% now that i have the 11 burst indicators (times, spike voltages and spike
% indices), i needed to reduce these indicators down to the median +/- some
% number of indices. this way, the sta algorithm only looks at the set of
% spikes we care about. let me state how the medians were determined. when
% there are an odd number of spikes in a burst, the median was simply the
% middle spike found in that burst. when there were an even number of
% spikes in a burst, the median doesnt work because it corresponds to the
% average of the two middle spikes; these cant be found, obviously, in the
% burst. Therefore, i simply took as the middle spike the total number of
% spikes in that burst divided by 2, so, if there were 42 spikes in a
% burst, the middle spike was 42/1=21. I felt this was a good compromise,
% as i am also including the observation immediately b4/after, so the
% middle is automatically included in the analysis
for ii=1:length(burstspikes)
%     ii
     %burstspiketimes{ii}
     % find median spike times in each burst
     % when there is even number of spikes in a burst, it is impossible 
     % to find the middle observation, so this would return a value of 1 as in "there is no middle time...
     if isempty(find(burstspiketimes{ii} == median(burstspiketimes{ii}))); 
          % /voltage or spike"
          burst_spiketimes_median_index = length(burstspiketimes{ii})/2;
     else % if there is a middle spike, this line finds it
          burst_spiketimes_median_index = find(burstspiketimes{ii} == median(burstspiketimes{ii})); 
     end
     
     %burst_spiketimes_median_index
     
     burst_spiketimes_before_median{ii} = burstspiketimes{ii}(burst_spiketimes_median_index:-1:(burst_spiketimes_median_index-spike_subtractor));
     % finds the 5 (or how many you want) spike times/voltages/spikes before the median
     burst_spiketimes_after_median{ii} = burstspiketimes{ii}(burst_spiketimes_median_index:1:(burst_spiketimes_median_index+spike_adder)); 
     % finds the 5 (or how many you want) spike times/voltages/spikes after the median
     burst_spiketimes_before_median_indices = burst_spiketimes_before_median{ii};
     burst_spikestimes_after_median_indices = burst_spiketimes_after_median{ii};
     burst_spiketimes_medians{ii} = [burst_spiketimes_before_median_indices(end:-1:2);burst_spikestimes_after_median_indices]; 
     % concatenates the times/voltages/spikes before and after the median into one vector.
     % because the two operations above it both involve the middle spike,
     % we have to make sure it doesnt occur twice in the time/voltage/spike
     % vectors. to do this, i start from the end of the vector before the
     % median and work back to the index just before the median. then i add
     % the second vector to it to create the appropriate vector

     % find median spike voltages. this is the same as above
     if isempty(find(burstspiketimes{ii} == median(burstspiketimes{ii})));
          burst_spikevoltages_median_index = length(burstspikevoltages{ii})/2;
     else
          burst_spikevoltages_median_index = burst_spiketimes_median_index;
     end
     burst_spikevoltages_before_median{ii} = burstspikevoltages{ii}(burst_spikevoltages_median_index:-1:(burst_spikevoltages_median_index-spike_subtractor));
     burst_spikevoltages_after_median{ii} = burstspikevoltages{ii}(burst_spikevoltages_median_index:1:(burst_spikevoltages_median_index+spike_adder));
     burst_spikevoltages_before_median_indices = burst_spikevoltages_before_median{ii};
     burst_spikevoltages_after_median_indices = burst_spikevoltages_after_median{ii};
     burst_spikevoltages_medians{ii} = [burst_spikevoltages_before_median_indices(end:-1:2);burst_spikevoltages_after_median_indices];

     % find median spike indices
     if isempty(find(burstspiketimes{ii} == median(burstspiketimes{ii})));
          burst_spikes_median_index = length(burstspikes{ii})/2;
     else
          burst_spikes_median_index = burst_spiketimes_median_index;
     end
     burst_spikes_before_median{ii} = burstspikes{ii}(burst_spikes_median_index:-1:(burst_spikes_median_index-spike_subtractor));
     burst_spikes_after_median{ii} = burstspikes{ii}(burst_spikes_median_index:1:(burst_spikes_median_index+spike_adder));
     burst_spikes_before_median_indices = burst_spikes_before_median{ii};
     burst_spikes_after_median_indices = burst_spikes_after_median{ii};
     burst_spikes_medians{ii} = [burst_spikes_before_median_indices(end:-1:2);burst_spikes_after_median_indices];
end

% the rest of the script extracts the values from the individual cells and
% places them into variables that can be used when they are passed back to
% the master script. this is done in several steps. here we create a matrix
% that the contents of the individual cells can be dumped into. the command
% cell2mat will create a one-column vector for each cell. in this case i
% will have a matrix that has 11 rows and 11 columns.
median_spiketimes_matrix = cell2mat(burst_spiketimes_medians);
median_spikevoltages_matrix = cell2mat(burst_spikevoltages_medians);
median_spikes_matrix = cell2mat(burst_spikes_medians);

% the next step is to determine the number of rows and columns in the
% matrices you created above. you might simply say that there were 11
% bursts and i had 11 indices, so the size should be 11x11 or a square matrix. While that will
% be mostly true, i wanted to automate it so that the matrix dimensions could be
% determined unambiguously.
time_rows_cols = size(median_spiketimes_matrix);
volt_rows_cols = size(median_spikevoltages_matrix);
spike_rows_cols = size(median_spikes_matrix);

% the final step is to take the columns and put them end to end. the matlab
% command reshape allows us to do that. to put it plainly, you tell reshape
% which matrix to work with, tell it how many rows it will need, and the
% number of columns in the array. we want a one column matrix, so the last
% input value is one
spikeTimeT=reshape(median_spiketimes_matrix,time_rows_cols(1)*time_rows_cols(2),1);
spikeVT=reshape(median_spikevoltages_matrix,volt_rows_cols(1)*volt_rows_cols(2),1);
spikeNNT=reshape(median_spikes_matrix,spike_rows_cols(1)*spike_rows_cols(2),1);

% once i have made the appropriate vecotrs, i just feed them into these
% variables. these then get passed back to the sta_5 script (@ line 82), where the sta
% analysis occurs
%dataSP = zeros(length(spikeTimeT),3);
dataSP = [spikeTimeT spikeVT spikeNNT];

disp('.............. end STA 4 .............')
end