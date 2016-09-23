function [timeAfterSpikeRemoval, voltAfterSpikeRemoval, postVolt] = ...
            getLeftSpikesInfo(dataS, idxAfterSpikeRemoval, postVect)
        
 timeAllSpikes = dataS(:,1);
 voltAllSpikes = dataS(:,2);
 indexAllSpikes = dataS(:,3);
 len = length(idxAfterSpikeRemoval);
 timeAfterSpikeRemoval = zeros(len,1);
 voltAfterSpikeRemoval = zeros(len,1);
 postVolt = zeros(len,1);
 
 disp(' ')
 %disp(['init time spk: ' mat2str(timeAllSpikes)])
 %disp(['init volt spk: ' mat2str(voltAllSpikes)])
 %disp(['init idx  spk: ' mat2str(indexAllSpikes)])
%  lenTime = length(timeAllSpikes);
%  diffTime = timeAllSpikes(2:lenTime) - timeAllSpikes(1:lenTime - 1);
%  aa = find(diffTime>=1);
%  numIBIinit = length(aa)
 
 %disp(['idx left spk: ' mat2str(idxAfterSpikeRemoval(1:50))])
 xx = zeros(len,1);
 for i = 1:len
     xx(i,1) = find(indexAllSpikes == idxAfterSpikeRemoval(i,1));
     timeAfterSpikeRemoval(i,1) = timeAllSpikes(xx(i,1));
     voltAfterSpikeRemoval(i,1) = voltAllSpikes(xx(i,1));
     postVolt(i,1) = postVect(xx(i,1));
 end
 
 % disp(['idx left spk: ' mat2str(xx)])
 %disp(' ' )
 %disp(['time left: ' mat2str(timeAfterSpikeRemoval)])
 %disp(['pre volt left: ' mat2str(voltAfterSpikeRemoval)])
 %disp(['post volt left: ' mat2str(postVolt)])
 %disp(['index left: ' mat2str(idxAfterSpikeRemoval)])
 spikesLeft = length(timeAfterSpikeRemoval)
 %length(voltAfterSpikeRemoval)
%  diffTime = timeAfterSpikeRemoval(2:spikesLeft) - timeAfterSpikeRemoval(1:spikesLeft - 1);
%  aa = find(diffTime>=1);
%  numIBIfin = length(aa)
 end