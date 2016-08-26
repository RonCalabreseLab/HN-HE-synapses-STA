function badSpk = getBadSpk(lennBT, nBT, NdiscardFirstT, NSpikesT)
 %      this for loop sets up the first spikes that are to be discarded.
 
   k=0;
   nbadSpikesT = [];
   tmp = [];

   for j = 1 : lennBT;
          k = k + 1;
          nbadSpikesT(k,1) = nBT(j);
          for i = 1 : NdiscardFirstT-1;
               tmp = nBT(j) + i;
               fprintf('%d', i);
               if j+i <= lennBT;
                    if (length(find(tmp == nBT(j:j+i))));
                         %    fprintf('Break %d',i);
                         break
                    else
                         k = k + 1;
                         nbadSpikesT(k,1) = tmp;
                    end
               elseif j+i <= NSpikesT;
                    k = k + 1;
                    nbadSpikesT(k,1) = tmp;
               end
          end
          %           fprintf('\n');
   end
  
   badSpk = nbadSpikesT;
   
   
        %      %%%%% try to get the last spikes in each burst
     %      k=0;
     %      for j=1:lennB;
     %           k=k+1;
     %           nbadSpikes(k,1)=nB(j);
     %           for i=1:NdiscardFirst-1;
     %                tmp=nB(j)+i;
     %                if j+i<=lennB;
     %                     if (length(find(tmp==nB(j:j+i))));
     %                          %    fprintf('Break %d',i);
     %                          break
     %                     else %this gets executed
     %                          k=k+1;
     %                          nbadSpikes(k,1)=tmp;
     %                     end
     %                elseif j+i<=NSpikes;
     %                     k=k+1;
     %                     nbadSpikes(k,1)=tmp;
     %                end
     %           end
     %           nbadSpikes;
     %      end
     %
     %      %      %%%%%%%%%%%%%%%%%%%%%%%%%%