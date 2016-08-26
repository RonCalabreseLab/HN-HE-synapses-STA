function [trToRem, spkFirstBur] = getTracesToBulkRemoval_1(postCell, ...
    spkL, spkR, idxLRVectFirstBur, indexAllSpikes)

len = length(postCell);
trToRem = cell(1, len);
spkFirstBur = zeros(1, spkL + spkR);

for i = 1:len
     pp = [];
     [~,c] = size(postCell{i});
     
     kk = 1;
     for j = 1:spkL
         pp(kk,1) = j;
         kk = kk + 1;
     end
     
     for j = (c-spkR+1):c
         pp(kk,1) = j;
         kk = kk + 1;
     end
     trToRem{i} = pp;
end


%%% for first burst
num = 0;
for i = 1:length(indexAllSpikes)
    k = indexAllSpikes(i);
    if ((k >= idxLRVectFirstBur(1)) && (k <= idxLRVectFirstBur(2)))
        num = num + 1;
    end
end

for i = 1:spkL
   spkFirstBur(1, i) = i; 
end
for j = (num - spkR + 1):num
    i = i + 1;
   spkFirstBur(1, i) = j;
end

%spkFirstBur
disp(['Total spks REF burst = ' num2str(num) ' spks to delete' ...
    mat2str(spkFirstBur)])
end