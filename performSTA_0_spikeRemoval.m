function performSTA_0_spikeRemoval(CT, invertCorrectionTrace, ...
    data, dataSP, IntervalNeg2, IntervalPos2, ISIburst, IntervalPSCNeg, ...
    indexLR_ofBursts, origFileName, nameHN, sta_method, CalcMin, ...
    xlabel1, ylabel1, tT, V, x_label, DataNames, minTimeH, maxTimeH, ...
    minVH, maxVH, thresh, peak, FalseSpike, burSPKtimes_med, ...
    burSPKvolt_med, FntS, IntervalPosLocal, IntervalNegLocal)

   
    %%% for Anca's plots uncomment the following lines %%%%%%%%%%%%%%
    [wint, NPointsWinPSCNeg, timeSpkTrI, preSpkTrI, postSpkTrI,...
            idxSpkTrI, avgPeriod] = sta_3_getSpkCloud(CT, ...
                invertCorrectionTrace, data, dataSP, IntervalNeg2, ...
                IntervalPos2, ISIburst, IntervalPSCNeg, indexLR_ofBursts);
        
     sizeDATA = size(data)
%     sizeWinF = size(winF)
%     sizePOST1 = size(postSpkTrI)
     sizeWINDOW = size(wint)
%     sizeDELtr = size(tracesToDelete)

    % get number of max spikes you can delete - ie, number of spikes of the 
    % biggest burst
    maxSpks = getMaxSpk(postSpkTrI);
    
    %%%%%%% window to get the bulk spike reduction info from user
    spkLeft = maxSpks;
    spkRight = maxSpks;
    flag = -1;
    while ((spkLeft + spkRight) > maxSpks)
        [flag, spkLeft, spkRight] = askWinSpikes(maxSpks);
        if ((spkLeft + spkRight) > maxSpks)
            h = errordlg('You must enter less number of spikes to be removed from bursts!!!','Bad Input','modal')
            uiwait(h);
        end
    end

    %reduce to desired spikes NNT
    %NNTx = 10; NNTy = 5; 
    NN = 0;
    postSpkTr = []; 
    idxSpkTr = [];
    disp(['Size of vector before any removal: ' num2str(size(data(:,1)))]);
    %timeSize = size(data(:,1))
    %preSize = size(data(:,2))
    %postSize = size(data(:,3))
    %postSpkI1 = size(postSpkTrI{1})
    %postSpkI2 = size(postSpkTrI{2})
    %postSpkI9 = size(postSpkTrI{9})
    %postSpkI10 = size(postSpkTrI{10}) %%% WHY IS 54
    %pp10 = postSpkTrI{10}; pp10(:,end)
    %sizeTimeI1 = size(timeSpkTrI{1})
    %sizeTimeI10 = size(timeSpkTrI{10}) %%% WHY IS 55
    %tt10 = timeSpkTrI{10}; tt10(:,end)
    %sizePreI1 = size(preSpkTrI{1})
    %sizePreI10 = size(preSpkTrI{10})
    %rr10 = preSpkTrI{10}; rr10(:,end)
    %aa10 = idxSpkTrI{10} %indices of L & R for 1st burst
    
    disp('Sizes after bulk removal')
    disp([' type of spike removal = ' num2str(flag)])
    
    if (flag == 1) || (flag == 0)
        %%% mainly here we get the list of spikes to be removed from each
        %%% burst, then we do plots and write data to files
        
        markToDel = cell(1, length(postSpkTrI));
        %%% bulk removal of spikes
        if (flag == 1) %Remove spikes from beginning and end of bursts
%             [timeSpkTr, preSpkTr, postSpkTr, idxSpkTr, NN, newTimeVec, ...
%                 newPreVec, newPostVec] = reduceToSpkOfInterest_1(timeSpkTrI, ...
%                 preSpkTrI, postSpkTrI, idxSpkTrI, spkLeft, spkRight, ...
%                 data(:,1), data(:,2), data(:,3));

        %%% removes the traces associated with the spikes to be removed
        [timeSpkTr, preSpkTr, postSpkTr, idxSpkTr, NN] = ...
            reduceToSpkOfInterest_1(timeSpkTrI, preSpkTrI, postSpkTrI, ...
            idxSpkTrI, spkLeft, spkRight);
        % note: only bulk removal is performed on the REF burst
         [tracesToBulkRemove, spkToRemFirstBurst] = ...
             getTracesToBulkRemoval_1(postSpkTrI, spkLeft, spkRight, ...
                indexLR_ofBursts{1}, dataSP(:,3));
%          t1 = tracesToBulkRemove{1}
%          t2 = tracesToBulkRemove{2}
%          t3 = tracesToBulkRemove{3}
%          t4 = tracesToBulkRemove{4}
%          t5 = tracesToBulkRemove{5}
%          t6 = tracesToBulkRemove{6}
%          t7 = tracesToBulkRemove{7}
%          t8 = tracesToBulkRemove{8}
%          t9 = tracesToBulkRemove{9}
%          t10 = tracesToBulkRemove{10}
         
        else %(flag == 0) %Keep spikes from middle spike to the left and right
            NN = spkLeft + spkRight + 1; %include also the middle spike
            [timeSpkTr, preSpkTr, postSpkTr, idxSpkTr] = ...
                reduceToSpkOfInterest(timeSpkTrI, preSpkTrI, ...
                    postSpkTrI, idxSpkTrI, spkLeft, spkRight);
            
            [tracesToBulkRemove, spkToRemFirstBurst, markToDel] = ...
                getTracesToBulkRemoval(postSpkTrI, spkLeft, spkRight, ...
                indexLR_ofBursts{1}, dataSP(:,3));
        end
        %%% end of bulk removal of spikes
              
        %get winF (average over good spikes) with used spikes only; NNT =
        %num of spikes is given by user
        winF = getAvgSpkUsed(wint, postSpkTr);        
        
        [MaxNum, MinNum, Max, Min, DifSyn] = calcAmplBiggestEvent(NN, ...
            winF, NPointsWinPSCNeg);
        
        
%          spkAfterBulkDel1 = size(postSpkTr{1})
%          spkAfterBulkDel2 = size(postSpkTr{2})
%          spkAfterBulkDel9 = size(postSpkTr{9})
%          spkAfterBulkDel10 = size(postSpkTr{10})
%          sizeTime1 = size(timeSpkTr{1})
%          sizeTime10 = size(timeSpkTr{10})
%          sizePre1 = size(preSpkTr{1})
%          sizePre10 = size(preSpkTr{10})
         
        
        plotBurstTracesOverlap(postSpkTr, IntervalNeg2, ...
            IntervalPos2, Max, Min, wint, FntS);
        
        %%% manual removal of spikes from each burst
        tracesToDelete = askWinDeletion(postSpkTr, IntervalNeg2, ...
            IntervalPos2, Max, Min, wint, FntS);
%         for i=1:length(tracesToDelete)
%            disp([' rem from burst ' num2str(i) ' spikes = ' mat2str(tracesToDelete{i})]) 
%         end

        if (~isempty(tracesToDelete))
            if (flag == 0)
                allTracesToRem = getFinalTracesToDel(tracesToDelete, ...
                    tracesToBulkRemove, markToDel)
            else
                allTracesToRem = getFinalTracesToDel_1(tracesToDelete, ...
                    tracesToBulkRemove, spkLeft)
            end
            %allTracesToRem{10}
        else
             %proceed with tracesToBulkRemove
             allTracesToRem = tracesToBulkRemove;
        end
        for i=1:length(allTracesToRem)
           disp([' rem from burst ' num2str(i) ' spikes = ' mat2str(allTracesToRem{i})]) 
        end
        %%% end of manual removal of spikes from each burst. At this point
        %%% we have the complete list of all spikes to be removed from each
        %%% burst in cell "allTracesToRem". Proceed to deleting spikes and
        %%% their traces!!!
        
        %newTimeVec, newPreVec, newPostVec,
        %data(:,1), data(:,2),data(:,3),
        newPostCell = getNewDataAfterDelTraces(allTracesToRem, ...
            dataSP, idxSpkTrI, postSpkTrI, ISIburst); 
        [idxAfterSpikeRemoval, idxRemSpikes, totalRemovedSpk] = ...
            getDataAfterSpikeRemoval(allTracesToRem, dataSP, ...
                indexLR_ofBursts, spkToRemFirstBurst);
        [timeAfterSpikeRemoval, preAfterSpikeRemoval, ...
            postAfterSpikeRemoval] = getLeftSpikesInfo(dataSP, ...
                idxAfterSpikeRemoval, data(:,3));
%         writeToFileNewData(origFileName, nameHN, strTopFile, ...
%             newNewTime, newNewPre, newNewPost);
%         writeToFileNewData(origFileName, nameHN, strTopFile, ...
%             timeAfterSpikeRemoval, preAfterSpikeRemoval, ...
%             postAfterSpikeRemoval);
        

        %%% from here starts plotting and writing to files
        newFileName = writeToFileNewTimes(origFileName, nameHN, dataSP(:,1), ...
            timeAfterSpikeRemoval);
        pause on;
        pause(10);
        pause off;
        disp('Sizes after bulk and manual removal')
        %sizePOST4_10 = size(postSpkTr{10})
        %sizeNewPost = size(newPost)
%         sizeNewPostCell1 = size(newPostCell{1})
%         sizeNewPostCell2 = size(newPostCell{2})
%         sizeNewPostCell9 = size(newPostCell{9})
%         sizeNewPostCell10 = size(newPostCell{10})
        

%%%%%%% CLOUD work starting
        %cloud with all spikes overlapping
        [avgTr, stdTr, goodSp, timestep, NPointsWinNegLocal, maxIPSC, ...
        maxIPSCNN, minIPSC, minIPSCNN, maxNegIPSC, maxNegIPSCNN, ...
        maxPosIPSC, maxPosIPSCNN, minNegIPSC, minNegIPSCNN, ...
        minPosIPSC, minPosIPSCNN, ...
        amplL, amplR, avgAmplL, avgAmplR, stdAmplL, stdAmplR] = getDataForPlotAvgCloud(newPostCell,...
                wint, IntervalNegLocal, IntervalPosLocal, origFileName);
    
        disp(['Final (total) used traces: ' num2str(goodSp)])  
    
        [idxSTDleft, idxSTDright] = plotSpkTrigAvgCloud(wint, newPostCell, origFileName, sta_method, ...
            CalcMin, xlabel1, ylabel1,  avgTr, stdTr, goodSp, ...
            NPointsWinNegLocal, maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, ...
            maxNegIPSC, maxNegIPSCNN, maxPosIPSC, maxPosIPSCNN, minNegIPSC, ...
            minNegIPSCNN, minPosIPSC, minPosIPSCNN, IntervalNeg2, ...
            IntervalPos2, nameHN, avgPeriod, totalRemovedSpk, ...
            avgAmplL, avgAmplR, stdAmplL, stdAmplR); 
        %cloud with all spikes of each burst overlapping
%         plotSpkTrigAvgCloud_1(wint, newPostCell, origFileName, ...
%             IntervalNegLocal, IntervalPosLocal, sta_method, CalcMin,...
%             yH, yL, xlabel1, ylabel1, IntervalNeg, IntervalPos); 


        %%%%%%%%%%% printing STDs of the remaining traces to file, along
        %%%%%%%%%%% with some stats
        printToFile_STDs(origFileName, nameHN, avgTr, stdTr, ...
            idxSTDleft, idxSTDright);

        %%% plot again traces with removed spikes
        %%% now create a figure that plots the voltage trace, along with the 
        %%% removed spikes and the lower and upper thresholds
        plotVoltageTraces_Fin(tT, V, x_label, DataNames, minTimeH, maxTimeH, ...
            minVH, maxVH, thresh, peak, dataSP(:,3), FalseSpike, CT,...
            burSPKtimes_med, burSPKvolt_med, newFileName);
        
        %%% Uncomment the following (7) lines till 'else' if you want to:
        %%% get traces after removal for plotting and writing them to file
        %%% NOTE: This takes about 50 min to complete...
%         [timeLeft, preLeft, postLeft] = getLeftData(data, idxRemSpikes);
%         plotVoltageTracesLeft(timeLeft, invertTriggeringTrace* preLeft, ...
%             x_label, DataNames, minTimeH, maxTimeH, minVH, maxVH, ...
%             thresh, peak, timeAfterSpikeRemoval, preAfterSpikeRemoval, ...
%             FalseSpike, CT, burSPKtimes_med, burSPKvolt_med);
%         writeToFileNewData(newFileName, 'new', strTopFile, timeLeft, ...
%             preLeft, postLeft)

     else % flag = -1 - means do not remove anything
            
            %get winF (average over good spikes) with used spikes only; NNT =
            %num of spikes is given by user
            winF = getAvgSpkUsed(wint, postSpkTrI);
            %[NN, aaa] = size(winF)%getAllNumSpikes(postSpkTrI)% keep all spikes 
            [a,b] = size(winF);            
            NN = min(a, getAllNumSpikes(postSpkTrI))
            
            
            [MaxNum, MinNum, Max, Min, DifSyn] = calcAmplBiggestEvent(NN, ...
                winF, NPointsWinPSCNeg);
    
            plotBurstTracesOverlap(postSpkTrI, IntervalNeg2, ...
                IntervalPos2, Max, Min, wint, FntS);
    
            %cloud with all spikes overlapping
            [avgTr, goodSp, timestep, NPointsWinNegLocal, maxIPSC, ...
            maxIPSCNN, minIPSC, minIPSCNN, maxNegIPSC, maxNegIPSCNN, ...
            maxPosIPSC, maxPosIPSCNN, minNegIPSC, minNegIPSCNN, ...
            minPosIPSC, minPosIPSCNN] = getDataForPlotAvgCloud(postSpkTrI,...
                wint, IntervalNegLocal, IntervalPosLocal, origFileName);
        
            
            %%%% this one below is not TESTED!!!!
% % %             plotSpkTrigAvgCloud(wint, postSpkTrI, origFileName, sta_method, ...
% % %                 CalcMin, xlabel1, ylabel1,  avgTr, goodSp, NPointsWinNegLocal, ...
% % %                 maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, maxNegIPSC, ...
% % %                 maxNegIPSCNN, maxPosIPSC, maxPosIPSCNN, minNegIPSC, ...
% % %                 minNegIPSCNN, minPosIPSC, minPosIPSCNN, IntervalNeg2, ...
% % %                 IntervalPos2, nameHN); 
            
            %%% this one is not the correct one; it is a copy of the
            %%% working removing spikes file (i.e., without OLD in the
            %%% fileName)
%         plotSpkTrigAvgCloudOLD(wint, postSpkTrI, origFileName, sta_method, ...
%                 CalcMin, xlabel1, ylabel1,  avgTr, stdTr, goodSp, NPointsWinNegLocal, ...
%                 maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, maxNegIPSC, ...
%                 maxNegIPSCNN, maxPosIPSC, maxPosIPSCNN, minNegIPSC, ...
%                 minNegIPSCNN, minPosIPSC, minPosIPSCNN, IntervalNeg2, ...
%                 IntervalPos2, nameHN, avgPeriod, totalRemovedSpk); 
%                 
            
            
            %     tracesToDelete = askWinDeletion(postSpkTr, IntervalNeg2, ...
            %              IntervalPos2, Max, Min, wint, FntS);
            % 
            %     tracesToDelete
%             hh = helpdlg('Press OK if done with the plots for this signal','Done');
%             uiwait(hh);
        
    end  
    %%% end Anca's plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



end