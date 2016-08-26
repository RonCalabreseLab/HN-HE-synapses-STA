function newPosCell = getNewDataAfterDelTraces(trToDelete, ...
    dataSPT, idxSpkTrTT, postCell, ISIburstT)

% remove traces in pre, post, and adjust time
% newTime = dataT(:,1); 
% newPre = dataT(:,2); 
% newPos = dataT(:,3);
newPosCell = postCell; %used to plot cloud
%l2 = size(newPosCell{2})
% np = size(newPos)

matrIdx = []; %each row is indices of [firstSpk, lastSpk] to delete
ix = 1;
%origSizeTime = size(timeOrig)
%origSizePre = size(preOrig)
%origSizePost = size(postOrig)

%go from big to small for easier adjustment of indices
for kk = length(trToDelete):-1:1
   if (~isempty(trToDelete{kk}))
         vv = trToDelete{kk};
         aux = idxSpkTrTT{kk};   
         auxpos = newPosCell{kk};
         disp(['burst = ' num2str(kk) '...sizeCellToDel = ' mat2str(size(vv)) ...
             ' ... sizeposCell = ' mat2str(size(auxpos))])
         for jj = length(vv):-1:1
             matrIdx(ix,1) = aux(1,vv(jj,1));
             matrIdx(ix,2) = aux(2,vv(jj,1));

             disp(['jj = ' num2str(jj) '...Remove from burst ' num2str(kk) ' trace ' ...
                 num2str(vv(jj,1)) ' with indices [' ...
                 num2str(matrIdx(ix,1)) ', ' num2str(matrIdx(ix,2)) ']']);
             
             auxpos(:,vv(jj,1)) = [];
             ix = ix + 1;
         end
         newPosCell{kk} = auxpos;
         disp(['...left cell size = ' num2str(size(auxpos))])
    end
end
%newSizeTime = size(newTime)
%newSizePre = size(newPre)
%newSizePost = size(newPos)
%l10 = size(newPosCell{10})

%%% dataSP has the spike/ burst recognized according to the global criteria
%%% dataSP = [spikeTime, spikeVoltage, spikeIndex]
totalSpikes = length(dataSPT)
ISI = dataSPT(2:totalSpikes, 1) - dataSPT(1:totalSpikes - 1, 1);%inter-spike intervals
nB = find(ISI >= ISIburstT); %+ 1 %Mike had here (+1) --- why???
numerOfBursts = length(nB) + 1% number of bursts
% nBI = nB(2:numerOfBursts) - nB(1:numerOfBursts-1); % interburst intervals found bw ISI
% lenNBI = length(nBI)
% for k = 1:lenNBI
%     adjNBI(k) = nBI(k) - 1;
% end%nBI(1:end)]
% adjNBI(lenNBI + 1) = totalSpikes - nB(end) - 1; % last burst is added
% adjNBI % = nB(i+1) - sum(nBI(i))



end


% % timeSP = dataSPT(:,1);
% % %voltSP = dataSPT(:,2);
% % %idxSP = dataSPT(:,3);
% % disp('.....Data of ...1st burst...the REF ...')
% % disp(['time spike 1 = ' num2str(timeSP(1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(1)))])
% % tr = 0;
% % for i = 1:nB(1) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 1st burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(1)-1))])
% % % disp(['index spike 1 = ' num2str(idxSP(1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(1)-1))])
% % 
% % disp('.....Data of ...2nd burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(1)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(1) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(2)))])
% % tr = 0;
% % for i = (nB(1) + 1):nB(2) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 2nd burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(1) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(2)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(1) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(2)))])
% % 
% % disp('.....Data of ...3rd burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(2)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(2) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(3)))])
% % tr = 0;
% % for i = (nB(2) + 1):nB(3) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 3rd burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(2) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(3)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(2) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(3)))])
% % 
% % disp('.....Data of ...4th burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(3)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(3) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(4)))])
% % tr = 0;
% % for i = (nB(3) + 1):nB(4) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 4th burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(3) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(4)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(3) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(4)))])
% % 
% % disp('.....Data of ...5th burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(4)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(4) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(5)))])
% % tr = 0;
% % for i = (nB(4) + 1):nB(5) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 5th burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(4) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(5)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(4) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(5)))])
% % 
% % disp('.....Data of ...6th burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(5)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(5) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(6)))])
% % tr = 0;
% % for i = (nB(5) + 1):nB(6) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 6th burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(5) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(6)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(5) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(6)))])
% % 
% % disp('.....Data of ...7th burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(6)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(6) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(7)))])
% % tr = 0;
% % for i = (nB(6) + 1):nB(7) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 7th burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(6) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(7)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(6) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(7)))])
% % 
% % disp('.....Data of ...8th burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(7)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(7) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(8)))])
% % tr = 0;
% % for i = (nB(7) + 1):nB(8) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 8th burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(7) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(8)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(7) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(8)))])
% % 
% % disp('.....Data of ...9th burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(8)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(8) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(9)))])
% % tr = 0;
% % for i = (nB(8) + 1):nB(9) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 9th burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(8) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(9)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(8) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(9)))])
% % 
% % disp('.....Data of ...10th burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(9)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(9) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(nB(10)))])
% % tr = 0;
% % for i = (nB(9) + 1):nB(10) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes 10 burst = ' num2str(tr)])
% % % disp(['volt spike 1 = ' num2str(voltSP(nB(9) + 1)) ' volt last spike = ' ...
% % %     num2str(voltSP(nB(10)))])
% % % disp(['index spike 1 = ' num2str(idxSP(nB(9) + 1)) ' index last spike = ' ...
% % %     num2str(idxSP(nB(10)))])
% % 
% % disp('.....Data of ...last burst...')
% % disp([' prev burst ... last spike time = ' num2str(timeSP(nB(10)))])
% % disp(['time spike 1 = ' num2str(timeSP(nB(10) + 1)) ' time last spike = ' ...
% %     num2str(timeSP(end) -1)])
% % tr = 0;
% % for i = (nB(10) + 1):length(timeSP) 
% %     if timeSP(i) > 0
% %         tr = tr +1;
% %     end
% % end
% % disp(['no spikes last burst = ' num2str(tr)])



% % disp(['volt spike 1 = ' num2str(voltSP(nB(10) + 1)) ' volt last spike = ' ...
% %     num2str(voltSP(end) -1)])
% % disp(['index spike 1 = ' num2str(idxSP(nB(10) + 1)) ' index last spike = ' ...
% %     num2str(idxSP(end) -1)])
% 
% % newTimeSpkRem = dataT(:,1); 
% % newPreSpkRem = dataT(:,2); 
% % newPosSpkRem = dataT(:,3);
% % newPosCellSpkRem = postCell; %used to plot cloud
% for kk = length(trToDelete):-1:2
%     if (~isempty(trToDelete{kk}))
%          vv = trToDelete{kk};
% %          for jj = length(vv):-1:1
% %              disp('_____________')
% %              disp(['__prev spike time = ' num2str(timeSP(nB(kk -1) + vv(jj,1) -1))])
% %              disp(['Remove from burst ' num2str(kk) ' spike number ' ...
% %                  num2str(vv(jj,1)) ' ... that has: spikeTime = ' ...
% %                  num2str(timeSP(nB(kk -1) + vv(jj,1) ))]) % ' voltage = ' ...
% %                  %num2str(voltSP(nB(kk -1) + vv(jj,1) )) ' index = ' ...
% %                  %num2str(idxSP(nB(kk -1) + vv(jj,1) ))])
% %              disp(['__next spike time = ' num2str(timeSP(nB(kk -1) + vv(jj,1) +1))])
% %              disp(['__next next spike time = ' num2str(timeSP(nB(kk -1) + vv(jj,1) +2))])
% %          end
%              disp('_____________')
%              jj = 1;
%              disp(['__prev spike time = ' num2str(timeSP(nB(kk -1) + vv(jj,1) -1))])
%              disp(['Remove from burst ' num2str(kk) ' spike number ' ...
%                  num2str(vv(jj,1)) ' ... that has: spikeTime = ' ...
%                  num2str(timeSP(nB(kk -1) + vv(jj,1) ))]) 
%              jj = length(vv);
%              disp(['__prev spike time = ' num2str(timeSP(nB(kk -1) + vv(jj,1) -1))])
%              disp(['Remove from burst ' num2str(kk) ' spike number ' ...
%                  num2str(vv(jj,1)) ' ... that has: spikeTime = ' ...
%                  num2str(timeSP(nB(kk -1) + vv(jj,1) ))]) 
%              
%     end
% end %for kk
% 
% disp('_____________')
% jj = 1;
% disp(['Remove from burst ' num2str(1) ' spike number ' ...
%                  num2str(vv(jj,1)) ' ... that has: spikeTime = ' ...
%                  num2str(timeSP(1))]) 
% jj = length(vv);
% disp(['__prev spike time = ' num2str(timeSP(nB(1) -1))])
% disp(['Remove from burst ' num2str(1) ' spike number ' ...
%                  num2str(vv(jj,1)) ' ... that has: spikeTime = ' ...
%                  num2str(timeSP(nB(1) ))]) 
%  