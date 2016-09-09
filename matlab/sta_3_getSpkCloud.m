% Terrence Michael Wright, September 10th, 2008
% sta_3_individual_sta.m This script is called by sta_1_master
% the purpose of this script is to take the voltage data from the
% extracellular trace, as well as the ipsc data from the last channel in
% your atf file. this data is then passed on to an sta algorithm contained
% within this script. the sta algorithm will take the average sta for a
% given spike across all the bursts(??!!). once that is done, the script
% generates a figure in which the individual spike sta's are splayed out
% across a number of rows. the number of rows on a given page are
% determined by the TracesPerPage entry in sta_1_master.

function [wintT, NPointsWinPSCNeg, timeSpkTraces, preSpkTraces, ...
          postSpkTraces, idxSpkTr, avg_period, timestep] = ...
        sta_3_getSpkCloud(CTT, invertCorrectionTraceT, dataT, dataSPT, ...
        IntervalNeg2T, IntervalPos2T, ISIburstT, IntervalPSCNegT, idxLRbursts)

% make a time variable and a voltage variable
%t = dataT(:,1);
%V = invertTriggeringTraceT * dataT(:,2);
%dt = size(dataT)
% only if you have a correction trace
if CTT == 1
     V0 = invertCorrectionTraceT * dataT(:,4); %%% ??? 4???
end

% note: FalseSpikeT is not used. Also, it is calc in sta_2 from an empty
% var. so it doesn't make any sense. To be removed later.
% [spikeTime, spikeV, spikeNN, FalseSpikeT] = sta_2_spike_detector(t, ...
%          TrefractoryT, threshT, peakT, CTT, V);
% size(spikeTime)
% size(spikeV)
% size(spikeNN)
     
% create a vector called dataSP just as you would in sta_1_master
%dataSP = [spikeTime spikeV spikeNN];
dataSP = dataSPT;

% determine the time step used
timestep = dataT(2,1) - dataT(1,1);

%% Apply high-pass filtering to attempt to remove baseline shifts
%% from current traces.
[filtDataI] = ...
    filterITraces(dataT(:,3), 5, 3000, timestep);

% display difference between original and filtered traces
figure; plot(dataT(:, 1), [dataT(:,3), filtDataI]);
legend('orig I', 'filtered');
title('High-pass filter of currents');
xlabel('time');
ylabel('current');

% these variables setup the time window for the spike triggered average
NPointsWinNeg = round(IntervalNeg2T/timestep);
NPointsWinPos = round(IntervalPos2T/timestep);
NPointsWin = NPointsWinNeg + NPointsWinPos;
NPointsWinPSCNeg = round(IntervalPSCNegT/timestep);

% % load the ipsc data
% data = dataT(:,3);
% len = length(data);

% det. IBI (interburst intervals)
NSpikes = length(dataSP);
ispike = dataSP(:,3);
ISI = dataSP(2:NSpikes,1) - dataSP(1:NSpikes-1,1); %diff bw consec spikes

nB = find(ISI >= ISIburstT);% + 1; %(interburst intervals)indices of 1st spike
%ISI(nB(1)-1) is the interburst interval; ISI(nB(1)) is the 1st spike of 
%the burst following this interval 

% of next burst found bw ISIs
lennB = length(nB); %number of bursts detected
if(lennB == 0)
     disp('No bursts\n');
     return;
end

% for k = 1:lennB
%    fprintf('IBI bw spike idx %d ... %d diff = %d \n',nB(k)-1, nB(k), ...
%        dataSP(nB(k),1) - dataSP(nB(k)-1,1)); % or ISI(nB(1)-1)
% end


nBI = nB(2:lennB) - nB(1:lennB-1); % interburst intervals found bw ISI
%MaxnBI = max(nBI);
%MeannBI = mean(nBI);

% num of points that can fit into the given interval (delay window)
wintT = (-NPointsWinNeg*timestep:timestep:(NPointsWinPos-1)*timestep)';
%size(wintT)
%winFT = [];
 
%  figure;
%  subplot(2,1,1)
%  plot(spikeTime,spikeV);title('Pre')
%  subplot(2,1,2)
%  plot(spikeTime,nBI);title('Post')


%%%% here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lenNBI = length(nBI);
% tmp var to keep the number of spikes in all bursts; first burst is always
% ignored; last burst has to be checked if has finished or not (ie it is
% entirely a burst or just a part of a burst!!!) TO DO
for k = 1:lenNBI
    adjNBI(k) = nBI(k);% - 1;
end%nBI(1:end)]
adjNBI(lenNBI + 1) = NSpikes - nB(end); % last burst is added
adjNBI % = nB(i+1) - sum(nBI(i))

disp(['Total number of spikes is ' num2str(sum(adjNBI))]);
%MeannBI = floor(mean(nBI));
disp(['The average number of spikes in each burst is ' ...
    num2str(floor(mean(adjNBI)))]);
spikeTime = dataSP(:,1);
avg_period = (mean(diff(spikeTime(nB))));
disp(['The average period is ' num2str(avg_period) ' seconds ']);

% load the ipsc data
%data = dataT(:,3);
%len = length(data);
% dataPre = dataT(:,2);
% dataTime = dataT(:,1);

%%% split orig data into cells of recognized bursts of traces
[timeSpkTraces, preSpkTraces, postSpkTraces, idxSpkTr] = ...
    splitVectToCellsOfTraces(adjNBI, NPointsWin, nB, ispike, ...
        NPointsWinNeg, NPointsWinPos, NSpikes, ...
        dataT(:,1), dataT(:,2), filtDataI, idxLRbursts);
  
end

% detect spike triggered event of each spike in pre signal (ie, 1st spk of
% 1st burst in pre, 1st spk of 2nd burst in pre, 1st spk of ... last burst
% in pre) - all these signals are averaged and later plotted; then same for
% 2nd spike, ... till NSpikeTrig traces are obtained
% % % % NNT = MaxnBI; % maximum IBI 
% % % % aa = 0;
% % % % for NSpikeTrig = 1:NNT
% % % %      win = zeros(NPointsWin,1);
% % % %      goodSp = 0;
% % % %      for i = 1:lennB-1
% % % %           if(nB(i) + NSpikeTrig < nB(i+1))
% % % %               if (ispike(nB(i) + NSpikeTrig) - NPointsWinNeg > 0 && ...
% % % %                    ispike(nB(i) + NSpikeTrig) + NPointsWinPos - 1 < len)
% % % %                         winTMP = data(ispike(nB(i) + NSpikeTrig) - ...
% % % %                             NPointsWinNeg:ispike(nB(i) + NSpikeTrig) + ...
% % % %                             NPointsWinPos - 1,1) - ...
% % % %                             data(ispike(nB(i) + NSpikeTrig),1);
% % % %                         %size(winTMP)
% % % %                         %ss2 = data(ispike(nB(i) + NSpikeTrig),1)
% % % %                         win = win + winTMP;
% % % %                         goodSp = goodSp + 1;
% % % %                end
% % % %           end
% % % %      end
% % % %      
% % % %      i = i + 1;
% % % %      if(nB(i) + NSpikeTrig < NSpikes)
% % % %           if (ispike(nB(i) + NSpikeTrig) - NPointsWinNeg > 0 && ...
% % % %               ispike(nB(i) + NSpikeTrig) + NPointsWinPos - 1 < len)
% % % %                     winTMP = data(ispike(nB(i) + NSpikeTrig) - ...
% % % %                         NPointsWinNeg:ispike(nB(i) + NSpikeTrig) + ...
% % % %                         NPointsWinPos - 1,1) - ...
% % % %                         data(ispike(nB(i) + NSpikeTrig),1);
% % % %                     win = win + winTMP;
% % % %                     goodSp = goodSp + 1;
% % % %           end
% % % %      end
% % % %     
% % % %      if goodSp <= NBurstsStatT
% % % %          break;
% % % %      end
% % % %      winFT(NSpikeTrig,:) = (win/goodSp)';% avg the traces
% % % %      %winFT(NSpikeTrig,1:5)
% % % %      %swft = size(winFT);
% % % %      goodSpFT(NSpikeTrig) = goodSp;
% % % %      aa = NSpikeTrig;
% % % %      
% % % %      %switch NSpikeTrig
% % % %      %    case {1,2,3,4,5}
% % % %                 %figure(NSpikeTrig);
% % % %                 %plot(wintT,winFT(NSpikeTrig,:));
% % % %      %end
% % % % end
% % % % NNT = aa; %number of good spikes = NNT + 1 within the desired bursts
% fprintf('Max no. of spikes that occured in at least %d bursts is %d\n',...
%              NBurstsStatT, NSpikeTrig);



% fid=fopen([file_nameInp 'ApmIPSC.dat'],'wn+');
% fprintf(fid,'%%Dependence of IPSC Amplitude on a Number of Spike in a burst. \n');
% fprintf(fid,'%%Window: Negative Interval= %-9.6g; Positive Interval=%-9.6g\n',IntervalNeg,IntervalPos);
% fprintf(fid,'%% The spike with this number should appear at least in %d bursts.\n',NBurstsStat);
% fprintf(fid,'%% Minimum of IPSC had to be within %-7.4g interval before the spike.\n',IntervalPSCNeg);
% fprintf(fid,'%%Spike#   Amplitude       MaxOccursAt\n');
% for NSpikeTrig=1:NNT
% fprintf(fid,'%d        %9.6f       %9.6f\n',NSpikeTrig,DifSyn(NSpikeTrig),wint(MaxNumT(NSpikeTrig)));
% end

%fclose all;