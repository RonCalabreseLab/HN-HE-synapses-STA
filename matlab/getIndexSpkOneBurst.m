function indexBurst = getIndexSpkOneBurst(indexLRbur, idxAllSpikes)

indexBurst = [];
j = 0;
num = 0;
for i = 1:length(idxAllSpikes)
    k = idxAllSpikes(i);
    if ((k >= indexLRbur(1)) && (k <= indexLRbur(2)))
        num = num + 1;
        j = j + 1;
        indexBurst(j) = k;
%      else
%         break;    
    end    
end

disp(['Total spks burst = ' num2str(num) ' indices = ' mat2str(indexBurst)])


end