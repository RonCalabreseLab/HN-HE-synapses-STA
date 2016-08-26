function [dataAfterSpikeRemoval, idxRemovedSpikes, idxLen] = ...
    getDataAfterSpikeRemoval(trToDelete, dataSPT, indexLRbur, spkToRemREFburst)

disp(' ' )
disp('.........in SPIKE REMOVAL ...........')

indexAllSpikes = dataSPT(:,3);
dataAfterSpikeRemoval = [];
lenIdx = length(indexLRbur)
leftBurstSpikes = cell(lenIdx, 1);
idxRemoved =  cell(lenIdx, 1);

vectLeftBurstSpikes = indexAllSpikes;
for jj = lenIdx:-1:2
    disp(['____burst ' num2str(jj)])
    indexREFBurst = getIndexSpkOneBurst(indexLRbur{jj}, vectLeftBurstSpikes);
    [leftBurstSpikes{jj}, idxRemoved{jj}] = deleteBurstSpikes(indexREFBurst, ...
        trToDelete{jj-1});
    idx = indexLRbur{jj-1};
%     vectLeftBurstSpikes = deleteSpikesFromData(vectLeftBurstSpikes, ...
%         idx(2), leftBurstSpikes);
end

%%% remove spikes REF burst
indexREFBurst = getIndexSpkOneBurst(indexLRbur{1}, vectLeftBurstSpikes);
[leftBurstSpikes{1}, idxRemoved{1}] = deleteBurstSpikes(indexREFBurst, ...
    spkToRemREFburst)

totLen = 0;
idxLen = 0;
for i = 1:lenIdx
    totLen = totLen + length(leftBurstSpikes{i});
    idxLen = idxLen + length(idxRemoved{i});
end
totLen
idxLen

aa = zeros(totLen,1);
bb = zeros(idxLen,1);
k = 1; kk = 1;
for i = 1:lenIdx
   xx = leftBurstSpikes{i};
   for j = 1:length(xx)
      aa(k,1) = xx(1,j);
      k = k + 1;
   end
   yy = idxRemoved{i};
   for j = 1:length(yy)
      bb(kk,1) = yy(j,1);
      kk = kk + 1;
   end
end

disp(['final (left) spikes = ' mat2str(aa)])
dataAfterSpikeRemoval = aa;
disp(['final (removed) spikes = ' mat2str(bb)])
idxRemovedSpikes = bb;
end

% %%% remove spikes other bursts
% disp('____burst 2')
% indexREFBurst = getIndexSpkOneBurst(indexLRbur{2}, indexAllSpikes);
% vectLeftBurstSpikes = deleteBurstSpikes(indexREFBurst, trToDelete{1})
% 
% disp('____burst 3')
% indexREFBurst = getIndexSpkOneBurst(indexLRbur{3}, indexAllSpikes);
% vectLeftBurstSpikes = deleteBurstSpikes(indexREFBurst, trToDelete{2})
% 
% disp('____burst 4')
% indexREFBurst = getIndexSpkOneBurst(indexLRbur{4}, indexAllSpikes);
% vectLeftBurstSpikes = deleteBurstSpikes(indexREFBurst, trToDelete{3})
% 
% disp('____burst 5')
% indexREFBurst = getIndexSpkOneBurst(indexLRbur{5}, indexAllSpikes);
% vectLeftBurstSpikes = deleteBurstSpikes(indexREFBurst, trToDelete{4})
% 
% disp('____burst 10')
% indexREFBurst = getIndexSpkOneBurst(indexLRbur{10}, indexAllSpikes);
% vectLeftBurstSpikes = deleteBurstSpikes(indexREFBurst, trToDelete{9})
% 
% disp('____burst 11')
% indexREFBurst = getIndexSpkOneBurst(indexLRbur{11}, indexAllSpikes);
% vectLeftBurstSpikes = deleteBurstSpikes(indexREFBurst, trToDelete{10})