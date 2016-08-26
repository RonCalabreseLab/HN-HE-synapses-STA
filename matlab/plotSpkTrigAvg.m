function plotSpkTrigAvg(wintT, winT, NPointsWinNegLocalT, ...
    NPointsWinPosLocalT, CalcMinT, xRT, yHT, goodSpT, xLT, yLT, ...
    xlabel1T, ylabel1T, file_nameInpT, sta_methodT)   
    
    figure;
    %for(j=1:goodSpT)
    h3 = plot(wintT,winT,'b');
    set(h3,'LineWidth',1);
    hold on;
   
    [maxIPSC maxIPSCNN] = max(winT);
    [minIPSC minIPSCNN] = min(winT);

    [maxNegIPSC maxNegIPSCNN] = max(winT(minIPSCNN - NPointsWinNegLocalT:minIPSCNN));
    
    %%% ADM: not sure it's correct, but at least the program will run without
    %%% error - TO FIX logical later
    if(minIPSCNN + NPointsWinPosLocalT) > length(winT)
        [maxPosIPSC maxPosIPSCNN] = max(winT(minIPSCNN:end));
    else
        [maxPosIPSC maxPosIPSCNN] = max(winT(minIPSCNN:minIPSCNN + NPointsWinPosLocalT));
    end
    
    [minNegIPSC minNegIPSCNN] = min(winT(maxIPSCNN - NPointsWinNegLocalT:maxIPSCNN));
    [minPosIPSC minPosIPSCNN] = min(winT(maxIPSCNN:maxIPSCNN + NPointsWinPosLocalT));

    if CalcMinT == 0
       plot(wintT(maxIPSCNN - NPointsWinNegLocalT + minNegIPSCNN - 1),...
            minNegIPSC,'+ r');
       plot(wintT(maxIPSCNN + minPosIPSCNN - 1), minPosIPSC,'+ m');
       plot(wintT(maxIPSCNN), maxIPSC, '+ m');
       str = num2str(maxIPSC - minPosIPSC);
       text(0.6 * xRT, 0.7 * yHT, ['AmpR= ' str]);
       str = num2str(maxIPSC - minNegIPSC);
       text(0.6 * xRT, 0.6 * yHT, ['AmpL= ' str]);
       str = num2str(wintT(maxIPSCNN));
       text(0.6 * xRT, 0.5 * yHT, ['Maximum at ' str]);
       str = num2str(goodSpT);
       text(0.6 * xRT, 0.4 * yHT, ['# of Spikes used = ' str]);
    else
       plot(wintT(minIPSCNN - NPointsWinNegLocalT + maxNegIPSCNN - 1), ...
           maxNegIPSC,'+ r');
       plot(wintT(minIPSCNN + maxPosIPSCNN - 1), maxPosIPSC,'+ m');
       plot(wintT(minIPSCNN), minIPSC, '+ m');
       str = num2str(maxPosIPSC - minIPSC);
       text(0.6 * xRT, 0.7 * yHT, ['AmpR= ' str]);
       str = num2str(maxNegIPSC - minIPSC);
       text(0.6 * xRT, 0.6 * yHT, ['AmpL= ' str]);
       str = num2str(wintT(minIPSCNN));
       text(0.6 * xRT, 0.5 * yHT, ['Minimum at ' str]);
       str = num2str(goodSpT);
       text(0.6 * xRT, 0.4 * yHT, ['# of Spikes used = ' str]);
    end
       str = num2str(file_nameInpT);
       text(0.0 * xRT, 0.9 * yHT, ['File:' str]);
       if sta_methodT == 0
           title('Global Spike Triggered Average');
       end
       if sta_methodT == 2   
        title('Median-Spike Based Spike Triggered Average');
       end
       %h3=plot(wintT,HNMean,'y-');
       hold on
       xlabel(xlabel1T);
       ylabel(ylabel1T);
       axis([xLT xRT yLT yHT]);
 end