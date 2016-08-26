function [timeSpk, preSpk, postSpk, idxSpk] = reduceToSpkOfInterest(timeI,...
    preI, postI, idxI, noSpkL, noSpkR)
%%% Keeps spikes from middle spike to the left and right 

% for an odd number of spikes in a burst, the median was simply the
% middle spike found in that burst. (9 => (9+1)/2 = 5 is the middle spike)
% for an even number of spikes in a burst, the middle spike is the total 
% number of spikes in that burst divided by 2. (10/2 =5 is the middle spike)

%totalSpk = noSpkL + noSpkR + 1;  
totalSpk = 0;
 for i=1:length(postI)
     [~,c] = size(postI{i});
     postMat = postI{i};
     timeMat = timeI{i};
     preMat = preI{i};
     idxMat = idxI{i};
     noSpkBur = c; %%% max num of spks
     midSpkIdx = 0;
     %matr = zeros(r, totalSpk);
     matrPos = [];
     matrPre = [];
     matrTim = [];
     matrIdx = [];
     idx = 1;
     if mod(noSpkBur,2) == 1 %odd
         midSpkIdx = (noSpkBur + 1) / 2;
         disp(['Middle spike for burst ' num2str(i) ' is ' num2str(midSpkIdx)])
     else %even
         midSpkIdx = noSpkBur / 2;  
         disp(['Middle spike for burst ' num2str(i) ' is ' num2str(midSpkIdx)])
     end
     
     if (midSpkIdx - noSpkL > 0)
        %disp('... midSpk > spkL ...')
        %idx
        for k = (midSpkIdx - noSpkL):midSpkIdx
            matrPos(:,idx) = postMat(:,k);
            matrPre(:,idx) = preMat(:,k);
            matrTim(:,idx) = timeMat(:,k);
            matrIdx(:,idx) = idxMat(:,k);
            %disp(['  ' num2str(k)])
            idx = idx + 1;
        end
        %idx
     else
         %disp('... too many spikesL -> keep all spikes on the left ...')
         %idx
         for k = 1:midSpkIdx
            matrPos(:,idx) = postMat(:,k); 
            matrPre(:,idx) = preMat(:,k);
            matrTim(:,idx) = timeMat(:,k);
            matrIdx(:,idx) = idxMat(:,k);
            %disp(['  ' num2str(k)])
            idx = idx + 1;
         end
         %idx
     end
     if (noSpkR + midSpkIdx <= c)
        %disp('... midSpk + spkL <= total spikes...')
        %idx
        for k = (midSpkIdx + 1):(midSpkIdx + noSpkR)
            matrPos(:,idx) = postMat(:,k);
            matrPre(:,idx) = preMat(:,k);
            matrTim(:,idx) = timeMat(:,k);
            matrIdx(:,idx) = idxMat(:,k);
            %disp(['  ' num2str(k)])
            idx = idx + 1;
        end
        %idx
     else
         %disp('... too many spikesR -> keep all spikes on the right ...')
         %idx
         for k = (midSpkIdx + 1):c
            matrPos(:,idx) = postMat(:,k);
            matrPre(:,idx) = preMat(:,k);
            matrTim(:,idx) = timeMat(:,k);
            matrIdx(:,idx) = idxMat(:,k);
            %disp(['  ' num2str(k)])
            idx = idx + 1;
         end
        %idx
     end
     
     postSpk{i} = matrPos;
     preSpk{i} = matrPre;
     timeSpk{i} = matrTim;
     idxSpk{i} = matrIdx;
     [c,r] = size(matrPos);
     totalSpk = totalSpk + r;
 end
  
  disp(['Total number of spikes left (after bulk spike removal) is: ' num2str(totalSpk)])
%   size(postSpk{1})
%   size(postSpk{2})
  clear postMat;
  clear timeMat;
  clear preMat;
  clear idxMat;
  clear matrPos;
  clear matrPre;
  clear matrTim;
  clear matrIdx;
end