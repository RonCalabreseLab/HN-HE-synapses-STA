function [timeSpk, preSpk, postSpk, idxSpk, NN] = ...
    reduceToSpkOfInterest_1(timeI, preI, postI, idxI, spkL, spkR)
                        
% Removes spikes from beginning and end of bursts

%NN = 0;
num = zeros(1,length(postI));
totalSpk = 0;

% perform bulk trace removal on cells
for i=1:length(postI)
     [~,c] = size(postI{i});
     
     if (spkL + spkR < c)   
        postMat = postI{i};
        timeMat = timeI{i};
        preMat = preI{i};
        idxMat = idxI{i};
         
        matrPos = [];
        matrPre = [];
        matrTim = [];
        matrIdx = [];
        idx = 1;        
         
        for k = (spkL + 1):(c-spkR)
            matrPos(:,idx) = postMat(:,k);
            matrPre(:,idx) = preMat(:,k);
            matrTim(:,idx) = timeMat(:,k);
            matrIdx(:,idx) = idxMat(:,k);
            idx = idx + 1;
        end
        num(1,i) = idx;
        disp(['Initial burst ' num2str(i) ' with ' num2str(c) ...
            ' spikes; reduced to ' num2str(idx-1) ' spikes'])
     else
         disp('Remove whole burst???')
         errordlg('Error: Too many spikes to be removed!!! Close and Rerun program.',...
             'Spike input error')
         %exit
         
     end
     
     totalSpk = totalSpk + idx -1;
     %size(matrPos)
     postSpk{i} = matrPos;
     preSpk{i} = matrPre;
     timeSpk{i} = matrTim;
     idxSpk{i} = matrIdx;
end

% % 
% % % perform bulk trace removal on initial vectors (signals)
% % matrIdx = []; %each row is indices of [firstSpk, lastSpk] to delete
% % ix = 1;
% % %go from big to small for easier adjustment of indices
% % for kk = length(postI):-1:1
% %          aux = idxI{kk};
% %          as = length(aux);
% %          %remove each trace (back, then front) from this cell
% %          for jb = as:-1:(as - spkR + 1)
% %             matrIdx(ix,1) = aux(1,jb);
% %             matrIdx(ix,2) = aux(2,jb); 
% %             disp(['Remove from burst (b) ' num2str(kk) ' trace ' ...
% %                  num2str(jb) ' with indices [' ...
% %                  num2str(matrIdx(ix,1)) ', ' num2str(matrIdx(ix,2)) ']'])
% %             newPostV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% %             newPreV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% %             newTimeV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% %             ix = ix + 1;
% %          end
% %          for jf = spkL:-1:1
% %             matrIdx(ix,1) = aux(1,jf);
% %             matrIdx(ix,2) = aux(2,jf); 
% %             disp(['Remove from burst (f) ' num2str(kk) ' trace ' ...
% %                  num2str(jf) ' with indices [' ...
% %                  num2str(matrIdx(ix,1)) ', ' num2str(matrIdx(ix,2)) ']'])
% %             newPostV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% %             newPreV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% %             newTimeV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% %             ix = ix + 1;
% %          end
% % %          for jj = length(vv):-1:1
% % %              matrIdx(ix,1) = aux(1,vv(jj,1));
% % %              matrIdx(ix,2) = aux(2,vv(jj,1));
% % %              disp(['Remove from burst ' num2str(kk) ' trace ' ...
% % %                  num2str(vv(jj,1)) ' with indices [' ...
% % %                  num2str(matrIdx(ix,1)) ', ' num2str(matrIdx(ix,2)) ']']) 
% % %              
% % %              newPostV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% % %              newPreV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% % %              newTimeV(matrIdx(ix,1):matrIdx(ix,2)) = []; %remove one trace
% % %              ix = ix + 1;
% % %          end
% %     
% % end

disp(['Total number of spikes (after bulk spike removal) is: ' num2str(totalSpk)])
%postSpk{1}
%postSpk{2}
clear postMat;
clear timeMat;
clear preMat;
clear idxMat;
clear matrPos;
clear matrPre;
clear matrTim;
clear matrIdx;
  
%disp(['init time ' num2str(size(timeVI)) ' ... reduced to ' num2str(size(newTimeV))])

NN = min(num);                    
                        
end                        