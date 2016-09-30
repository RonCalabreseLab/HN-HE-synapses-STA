function [timesSpkTracesT, preSpkTracesT, postSpkTracesT, ...
    idxSpkTrT] = splitVectToCellsOfTraces(adjNBIT, ...
    NPointsWinT, nBT, ispikeT, NPointsWinNegT, NPointsWinPosT, ...
    NSpikesT, dataTime, dataPre, dataPost, idxLRbur, subPreSpikeData)

%disp('....in SPLIT ....')
lenADJ = length(adjNBIT);
lenT = length(dataPost);
% lpre = length(dataPre)
% ltime = length(dataTime)
%disp('in splitVectToCellsOfTraces...')
%adjNBIT
%nBT

%alg. goes for each burst. It will show all the spikes withing the burst,
%ie all post events for all pre spikes in a cloud for each burst
postSpkTracesT = cell(1,lenADJ); % cell of traces; each cell is a 
%matrix corresponding to the traces of its spikes
preSpkTracesT = cell(1,lenADJ); % cell of traces corr to the post traces
timesSpkTracesT = cell(1,lenADJ); % cell of traces corr to times of post
idxSpkTrT = cell(1,lenADJ); % cell of idices of each trace

 for i = 1:lenADJ-1 %for each burst, adjNBIT(i) gives the number of 
     % spikes in burst in burst i (1st burst was ignored).
     % same: initialize window for burst analysis
     %win = zeros(NPointsWinT,1); % temp trace for one spike
     winTP = zeros(NPointsWinT, adjNBIT(i)); % temp matrix for POST
     winTPpre = zeros(NPointsWinT, adjNBIT(i)); % temp matrix for PRE
     winTPtime = zeros(NPointsWinT, adjNBIT(i)); % temp matrix for TIME
     winTidx = zeros(2, adjNBIT(i)); % temp for [indexLeft; indexRight] of each trace
     %goodSp = 0;
     %fprintf('Burst %d ...noSpksBur(%d) = %d ...\n', i, i, adjNBIT(i));
     %aa = idxLRbur{i+1}
     for NSpikeTrig = 1:adjNBIT(i) %each pre spike of a burst i
         %fprintf('Spike %d ... ', NSpikeTrig);
         postSpkWin = zeros(NPointsWinT, 1); % temp trace for one spike
         tmpIdx = nBT(i) + NSpikeTrig;
         %disp(['tmpIdx = ' num2str(tmpIdx)]);
         if(tmpIdx <= nBT(i+1))
              if (ispikeT(tmpIdx) - NPointsWinNegT > 0 && ...
                   ispikeT(tmpIdx) + NPointsWinPosT - 1 < lenT)
                        %disp(['ispikeT(tmpIdx) = ' num2str(ispikeT(tmpIdx))]);
                        idxL = ispikeT(tmpIdx) - NPointsWinNegT;
                        idxR = ispikeT(tmpIdx) + NPointsWinPosT - 1;
%                         disp(['ispikeT(tmpIdx) = ' num2str(ispikeT(tmpIdx)) ...
%                             ' idxL = ' num2str(idxL) ' idxR = ' num2str(idxR)])
                        postSpkWin = dataPost(idxL:idxR,1);
                        if subPreSpikeData 
                          postSpkWin = postSpkWin - dataPost(ispikeT(tmpIdx),1);
                        end
                        winTP(:,NSpikeTrig) = postSpkWin;
                        postSpkWin = dataPre(idxL:idxR,1);
                        if subPreSpikeData 
                          postSpkWin = postSpkWin - dataPre(ispikeT(tmpIdx),1);
                        end
                        winTPpre(:,NSpikeTrig) = postSpkWin;
                        postSpkWin = dataTime(idxL:idxR,1);
                        if subPreSpikeData 
                          postSpkWin = postSpkWin - dataTime(ispikeT(tmpIdx),1);
                        end
                        winTPtime(:,NSpikeTrig) = postSpkWin;
                        winTidx(:,NSpikeTrig) = [idxL; idxR];
                        %win = win + postSpkWin;
                        %goodSp = goodSp + 1;
               end
          end
     end
     fprintf('\n');
     postSpkTracesT{i} = winTP;
     preSpkTracesT{i} = winTPpre;
     timesSpkTracesT{i} = winTPtime;
     idxSpkTrT{i} = winTidx;
 end
 
 
 %last burst 
 %disp('>> last burst')
 i = lenADJ;
 %%% NOTE: last trace is filled with 0s and we use -1 to remove it
 winTP = zeros(NPointsWinT,adjNBIT(i) );%- 1); % temp --- was -1
 winTPpre = zeros(NPointsWinT,adjNBIT(i) );%- 1); % temp 
 winTPtime = zeros(NPointsWinT,adjNBIT(i) );%- 1); % temp 
 winTidx = zeros(2,adjNBIT(i) );%- 1); % temp --- was -1
 %fprintf('Burst %d ...\n', i);
 for NSpikeTrig = 1:adjNBIT(i)%-1 %each pre spike of a burst i
     %fprintf('Spike %d ... ', NSpikeTrig);
     postSpkWin = zeros(NPointsWinT,1); % temp trace for one spike
     tmpIdx = nBT(i) + NSpikeTrig;
     %disp(['tmpIdx = ' num2str(tmpIdx)]);
     if(tmpIdx <= NSpikesT)
           if (ispikeT(tmpIdx) - NPointsWinNegT > 0 && ...
              ispikeT(tmpIdx) + NPointsWinPosT - 1 < lenT)
                idxL = ispikeT(tmpIdx) - NPointsWinNegT;
                idxR = ispikeT(tmpIdx) + NPointsWinPosT - 1;
%                 disp(['ispikeT(tmpIdx) = ' num2str(ispikeT(tmpIdx)) ...
%                     ' idxL = ' num2str(idxL) ' idxR = ' num2str(idxR)])
                %disp(['idxL = ' num2str(idxL) ' idxR = ' num2str(idxR)])
                postSpkWin = dataPost(idxL:idxR,1);
                if subPreSpikeData 
                  postSpkWin = postSpkWin - dataPost(ispikeT(tmpIdx),1);
                end
                winTP(:,NSpikeTrig) = postSpkWin;
                postSpkWin = dataPre(idxL:idxR,1);
                if subPreSpikeData 
                  postSpkWin = postSpkWin - dataPre(ispikeT(tmpIdx),1);
                end
                winTPpre(:,NSpikeTrig) = postSpkWin;
                postSpkWin = dataTime(idxL:idxR,1);
                if subPreSpikeData 
                  postSpkWin = postSpkWin - dataTime(ispikeT(tmpIdx),1);
                end
                winTPtime(:,NSpikeTrig) = postSpkWin;
                winTidx(:,NSpikeTrig) = [idxL; idxR];
                  %win = win + postSpkWin;
                  %goodSp = goodSp + 1;
           end
     end
 end
 %fprintf('\n');
 postSpkTracesT{i} = winTP;
 preSpkTracesT{i} = winTPpre;
 timesSpkTracesT{i} = winTPtime;
 idxSpkTrT{i} = winTidx;
 %size(postSpkTraces{i})
 clear i;
 clear winTP;
 clear postSpkWin;
 clear winTPpre;
 clear winTPtime;
 %disp('....end SPLIT ....')
end