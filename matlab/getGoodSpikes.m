function [goodSPK, wint, win] = getGoodSpikes(NSpikesT, NdiscardLastT, ...
    nbadSpikesT, ispikeT, NPointsWinNegT, NPointsWinPosT, dataT, ...
    OverlayT, timestepT, NPointsWinT, lenT)

gooSpk = 0;
wint=(-NPointsWinNegT * timestepT : timestepT : (NPointsWinPosT-1) * timestepT)';
win = zeros(NPointsWinT, 1);

  for j = 1 : NSpikesT - NdiscardLastT; %original code
          if NdiscardLastT > NSpikesT;
               fprintf('NdiscardLast > NSpikes\n');
               break;
          end
          if find(j == nbadSpikesT);
               %fprintf('\nB %d\n',j);
          else
               gooSpk = gooSpk + 1;
               % fprintf('G%d',j);
               if (ispikeT(j) - NPointsWinNegT > 0 && ...
                   ispikeT(j) + NPointsWinPosT - 1 < lenT);
                    %win(:,goodSp)=data(ispike(j)-NPointsWinNeg:ispike(j)+NPointsWinPos-1,1)-data(ispike(j),1);
                    winTMP = dataT(ispikeT(j) - NPointsWinNegT:ispikeT(j) + ...
                        NPointsWinPosT - 1, 1) - dataT(ispikeT(j), 1);
                    if OverlayT
                        plot(wint,winTMP,'y');
                        hold on;
                    end
                    win = win + winTMP;
               end
          end
    end
    goodSPK = gooSpk;
end