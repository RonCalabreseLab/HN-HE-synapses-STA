% Terrence Michael Wright, September 10th, 2008
% sta_2_spike_detector.m This script is called by sta_1_master
% the purpose of this script is to take the voltage data from the
% extracellular trace, find the spikes in the recording, then kick them
% back to the sta_1_master script. the algorithm is executed as follows: in
% sta_1_master, you indicate an upper and lower threshold. these thresholds
% set the voltage at which a spike can be triggered (lower threshold), but
% does not cross a maximum value (upper threshold). the algorithm separates
% spikes by including a refractory period in which, if the voltage
% recrosses that lower threshold, it is not treated as a spike. in addition to spikes,
% the script determines the times of those spikes and the peak voltage associated
% the spikes. Once these have been determined, the script generates a figure in which it
% plots the voltage, along with the associated determined spikes as well as
% the upper and lower thresholds.Finally, after the figure is generated,
% the script generates the variables that will be kicked back to
% sta_1_master; namely, the spiketimes, spikevoltages and spikes. these are
% played back to the sta_5 script (@ line 27)

% determine the min and max times of the epoch of voltage data you are
% analyzing
function [spikeTimeH, spikeVH, spikeNNH, ...
    FalseSpike] = sta_2_spike_detector(tT, TrefractoryT, ...
                                       threshT, peakT, CTT, V)

spikeTimeH = [];
spikeVH = [];
spikeNNH = [];

spikeVAux = [];

% should set interspike duration
FalseSpike = [];

minInterSpikeDurN = floor(TrefractoryT/(tT(2)-tT(1)));

% Here is where the spike detection algorithm begins

% first find voltages that above threshold
SpikesAboveThresh = find(V>threshT);
noSpikesAboveThresh = length(SpikesAboveThresh)
sizeSpkAboveTH = size(SpikesAboveThresh);

% creates a one-column vector of values that has the following information:
% 0 in row one, all the voltage values above threshold, and the final row
% being a the length of V (in this case, 98504)
AbovN = [0;SpikesAboveThresh;length(V)];

% the number of columns in the AbovN vector created above
lenAbovN = length(AbovN)

% now take the difference between the detected spike crossings. in this
% case the differences taken start with row two (remember o is in the first
% row), and going through the second to last value (remember the length of
% the voltage data column is in the last row. 
dfAbovN = AbovN(2:lenAbovN)-AbovN(1:lenAbovN-1);

% now find the spike intervals greater than the minimum interspike
% interval. this should equal the number of spikes detected in the trace
spNNdfAbovN = find(dfAbovN>minInterSpikeDurN);

% create a vector equal to the number of spikes
SpikesNum=length(spNNdfAbovN)

% this for loop gets the peak voltage for all of the determined spikes
% found. this loop will identify two consecutive spike indices, then
% determine the max voltage between those two points (line 64). this max is
% then compared to the upper threshold that you set in sta_1_master (350 by
% default, line 67). if it is less than the peak, it gets added to the
% spikeNN variable (69). then the variable i_spike is incremented by one
% and the process is repeated for each spike. because we are looking at the
% max between two separate indices, the total number of spikes we should
% end up with is (total # spikes above threshold) - 1 spikes.
i_spike=1;
for i=1:SpikesNum-1
     n1 = AbovN(spNNdfAbovN(i)+1);
     n2 = AbovN(spNNdfAbovN(i+1));
     [spikeVAux(i_spike) spikeNaux(i_spike)]=max(V(n1:n2));
     if (max(V(n1:n2))<=peakT);
          spikeNNH(i_spike)=spikeNaux(i_spike)+n1-1;
          i_spike=i_spike+1;
     end
end

% create an empty variable corresponding to the length of spikeVAux
lenspikeV=length(spikeVAux);

%if an error message sent you here, no spikes were detected in this program
lenspikeNN=length(spikeNNH);
if CTT==1; %only execute this part of the code if you have a correction trace
     lenspikeNN0=length(spikeNN0);
     spike0distance=15;%maximum distance a false spike can be from a spike in program SpikeNotTriggeredSTA(in miliseconds)
     spikeNN1=reshape(spikeNNH,lenspikeNN,1);
     spike0=zeros(lenspikeNN,1);
     for i=1:lenspikeNN0
          spike0(i)=spikeNN0(i);
     end
     FS=1;
     for i=1:lenspikeNN
          for j=-spike0distance:spike0distance
               D=find(spike0(i)==spikeNNH+j);
               if D
                    X(FS)=spikeNNH(D);
                    spikeVAux(D)=[];
                    spikeNNH(D)=[];
                    FS=FS+1;
               end
          end
     end
     FalseSpike=X';
     %test=[spikeNN1 spike0];
end

lenSpkNNH = length(spikeNNH);
% % % now create a figure that plots the voltage trace, along with the detected
% % % spikes and the lower and upper thresholds
% plotVoltageTraces(tT, V, x_label, DataNames, minTimeH, maxTimeH, ...
%     minVH, maxVH, thresh, peak, spikeNNH, FalseSpike, CT)

%  these commands create variables that will be passed back to sta_1_master
spikeTimeAux=tT(spikeNNH); %times of spikes
spLn=length(spikeTimeAux);
dfSpikeTimeAux=spikeTimeAux(2:spLn)-spikeTimeAux(1:spLn-1);
spikeTimeNAux1=find(dfSpikeTimeAux<TrefractoryT);
spikeNNH(spikeTimeNAux1+1)=[];
spikeTimeAux(spikeTimeNAux1+1)=[];
spikeVAux(spikeTimeNAux1+1)=[];
spikeTimeH=spikeTimeAux;
spikeVH=spikeVAux';
clear spikeTimeAux;


% these commands appear to set the spikeNNH variable to be passed back to
% sta_1_master
B=length(spikeNNH);
A=reshape(spikeNNH,B,1);
spikeNNH=A;

end