
function showFig_Avg(figName, winT, avgTr, NPointsWinNegLocalT, maxIPSC, ...
    maxIPSCNN, minIPSC, minIPSCNN, maxNegIPSC, maxNegIPSCNN, maxPosIPSC, ...
    maxPosIPSCNN, minNegIPSC, minNegIPSCNN, minPosIPSC, minPosIPSCNN, ...
    IntervalNeg2T, IntervalPos2T, CalcMinT, str0T, strT, xlabel1T, ...
    ylabel1T, nameHNsigT)

fff = figure('Name', figName, 'NumberTitle','off', 'position', [150 200 800 550]);

%%% plot first panel with traces
titlePanel = 'Average Curve for Global';

figPanel = uipanel('Title',titlePanel,'FontSize',12,...
                 'Position',[.01 .01 .98 .97]);
ax = axes('Parent', figPanel,'Position',[0.1 0.1 .85 .85]);%,...
              %'Visible','off');
 
switch nameHNsigT
    case '3'
        pxx = plot(ax, winT, avgTr, 'b', 'LineWidth', 2);
    case '4'
        pxx = plot(ax, winT, avgTr, 'g', 'LineWidth', 2);
    case '6'
        pxx = plot(ax, winT, avgTr, 'm', 'LineWidth', 2);
    case '7'
        pxx = plot(ax, winT, avgTr, 'c', 'LineWidth', 2);
    otherwise
        pxx = plot(ax, winT, avgTr, 'r', 'LineWidth', 2);
    
end              
%pxx = plot(ax, winT, avgTr, 'r', 'LineWidth', 2);
%set(hff,'LineWidth',2);
hold on


if CalcMinT == 0
    if (maxIPSCNN - NPointsWinNegLocalT > 0)
        plot(ax, winT(maxIPSCNN - NPointsWinNegLocalT + minNegIPSCNN - 1),...
             minNegIPSC,'+ g');
    else
        plot(ax, winT(minNegIPSCNN), minNegIPSC,'+ g');
    end
    plot(ax, winT(maxIPSCNN + minPosIPSCNN - 1), minPosIPSC,'+ g');
    plot(ax, winT(maxIPSCNN), maxIPSC, '+ g');

else
    if (minIPSCNN - NPointsWinNegLocalT >0)
        plot(ax, winT(minIPSCNN - NPointsWinNegLocalT + maxNegIPSCNN - 1), ...
            maxNegIPSC,'+ g');
    else
        plot(ax, winT(minIPSCNN + maxNegIPSCNN - 1), ...
            maxNegIPSC,'+ g');
    end
    plot(ax, winT(minIPSCNN + maxPosIPSCNN - 1), maxPosIPSC,'+ g');
    plot(ax, winT(minIPSCNN), minIPSC, '+ g');

end

%        %h3=plot(wintT,HNMean,'y-');
hold on
xlabel(xlabel1T);
ylabel(ylabel1T);
%axis([xLT xRT yLT yHT]);

%% put timeline - interval shrinks according to the number of removed
%% traces
text(0, 0 , '|', 'FontSize',10,'FontWeight','bold',...
      'color',[0.1 0.9 0.1]);
text(0, .001, '0', 'FontSize',10,'FontWeight','bold',...
      'color',[0.1 0.9 0.1]);
text(winT(1,1), 0 , '|', 'FontSize',10,'FontWeight','bold',...
      'color',[0.1 0.9 0.1]);
text(winT(1,1)+0.002, 0 , num2str(IntervalNeg2T), 'FontSize',10,...
      'FontWeight','bold', 'color',[0.1 0.9 0.1]);
text(winT(end,1), 0 , '|', 'FontSize',10,'FontWeight','bold',...
      'color',[0.1 0.9 0.1]);
text(winT(end,1)-0.02, 0 , num2str(IntervalPos2T), 'FontSize',10,...
      'FontWeight','bold', 'color',[0.1 0.9 0.1]);

text(0.6*winT(end,1), 0.8*maxIPSC, strT, 'HorizontalAlignment','left') 
text(0.9*winT(1,1), 0.9*maxIPSC, str0T);
axis tight
hold off

end