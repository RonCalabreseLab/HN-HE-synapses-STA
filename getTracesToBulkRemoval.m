function [trToRem, spkFirstBur, markDel] = getTracesToBulkRemoval(postCell, ...
    spkL, spkR, idxLRVectFirstBur, indexAllSpikes)
%Keep spikes from middle spike to the left and right
 
len = length(postCell);
trToRem = cell(1, len);
markDel = cell(1, len); % 0 means remove; 1 is to keep

for i = 1:len
     pp = [];
     [~,c] = size(postCell{i});
     midSpk = ceil(c/2);
     auxMark = ones(1,c); %initial keep all spikes
     disp(['burst ' num2str(i) ' with ' num2str(c) ' spikes has middle spike ' ...
         num2str(midSpk)])     
     if (mod(c,2)) % even number of spikes - we assume 2 middle spikes
         % midSpk1 = midSpk and midSpk2 = midSpk + 1; those are kept by
         % default - so total kept is (spkL + spkR)
         %disp('... even ...')
         noSpksRemLeft = midSpk - spkL - 1;
         noSpksRemRight = c - midSpk - spkR;
     else % odd number of spikes - there is 1 middle spike, midSpk
         % total kept is (spkL + spkR + 1)
         %disp('... odd ...')
         noSpksRemLeft = midSpk - spkL - 1;
         noSpksRemRight = c - midSpk - spkR;
     end
     
     kk = 1;
     for j = 1:noSpksRemLeft
         pp(kk,1) = j;
         kk = kk + 1;
     end
     
     for j = (c-noSpksRemRight+1):c
         pp(kk,1) = j;
         kk = kk + 1;
     end
     disp([' ... spikes to remove from this burst ' mat2str(pp)])
     for ss = 1:length(pp)
        auxMark(1,pp(ss,1)) = 0; 
     end
     trToRem{i} = pp;
     markDel{i+1} = auxMark;
     disp(['marked: ' mat2str(auxMark)])
end

%%% for first burst
num = 0;
%c = length(indexAllSpikes);
for i = 1:c
    k = indexAllSpikes(i);
    if ((k >= idxLRVectFirstBur(1)) && (k <= idxLRVectFirstBur(2)))
        num = num + 1;
    end
end

auxMark = ones(1,num); %initial keep all spikes
midSpk = ceil(num/2)
if (mod(num,2)) % even number of spikes - we assume 2 middle spikes
         % midSpk1 = midSpk and midSpk2 = midSpk + 1; those are kept by
         % default - so total kept is (spkL + spkR)
         noSpksRemLeft = midSpk - spkL;
         noSpksRemRight = num - midSpk - spkR;
else % odd number of spikes - there is 1 middle spike, midSpk
         % total kept is (spkL + spkR + 1)
         noSpksRemLeft = midSpk - spkL - 1;
         noSpksRemRight = num - midSpk - spkR;
end
for i = 1:noSpksRemLeft
   spkFirstBur(1, i) = i; 
   auxMark(1,i) = 0;
end
for j = (num - noSpksRemRight + 1):num
    i = i + 1;
   spkFirstBur(1, i) = j;
   auxMark(1,j) = 0;
end

markDel{1} = auxMark;
%spkFirstBur
disp(['Total spks REF burst = ' num2str(num) ' spks to delete' ...
    mat2str(spkFirstBur) ' ..marked = ' mat2str(auxMark)])

end