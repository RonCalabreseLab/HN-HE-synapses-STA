function showFig_CloudAvg(figName, sta_methodT, traces, winT, avgTr, ...
    NPointsWinNegLocalT, maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, ...
    maxNegIPSC, maxNegIPSCNN, maxPosIPSC, maxPosIPSCNN, minNegIPSC, ...
    minNegIPSCNN, minPosIPSC, minPosIPSCNN, IntervalNeg2T, IntervalPos2T,...
    CalcMinT, str0T, strT, xlabel1T, ylabel1T)

%'SpkTrigAvg Cloud'
%%% fig 1 with the cloud and the avg
ff = figure('Name', figName, 'NumberTitle','off', ...
    'position', [50 200 700 550]);

%%% plot first panel with traces
titlePanel = '';
if sta_methodT == 0
    titlePanel = 'Global Spike Triggered Average';
end
if (sta_methodT == 2 || sta_methodT == 1)
    titlePanel = 'Median-Spike Based Spike Triggered Average';
end
figPanel = uipanel('Title',titlePanel,'FontSize',12,...
                 'Position',[.01 .01 .98 .97]);
ax = axes('Parent', figPanel,'Position',[0.1 0.1 .85 .85]);%,...
              %'Visible','off');

maxTr = 0;
for ii = 1: length(traces)
   vv = traces{ii};
   [~,cc] = size(vv);
   for jj = 1:cc
      %plot(winT, vv(:,jj), 'b')
      px = plot(ax, winT, vv(:,jj), 'b');
      %size(vv(:,jj))
      aa = max(vv(:,jj));
      maxTr = max(maxTr, aa);
      hold on;
   end
end

pxx = plot(ax, winT, avgTr, 'r', 'LineWidth', 2);
%set(hff,'LineWidth',2);
hold on


if CalcMinT == 0
    if (maxIPSCNN - NPointsWinNegLocalT > 0)
        plot(ax, winT(maxIPSCNN - NPointsWinNegLocalT + minNegIPSCNN - 1),...
             minNegIPSC,'+ y');
    else
        plot(ax, winT(minNegIPSCNN), minNegIPSC,'+ y');
    end
    plot(ax, winT(maxIPSCNN + minPosIPSCNN - 1), minPosIPSC,'+ y');
    plot(ax, winT(maxIPSCNN), maxIPSC, '+ y');

else
    if (minIPSCNN - NPointsWinNegLocalT >0)
        plot(ax, winT(minIPSCNN - NPointsWinNegLocalT + maxNegIPSCNN - 1), ...
            maxNegIPSC,'+ y');
    else
        plot(ax, winT(minIPSCNN + maxNegIPSCNN - 1), ...
            maxNegIPSC,'+ y');
    end
    plot(ax, winT(minIPSCNN + maxPosIPSCNN - 1), maxPosIPSC,'+ y');
    plot(ax, winT(minIPSCNN), minIPSC, '+ y');

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
text(0, -.35, '0', 'FontSize',10,'FontWeight','bold',...
      'color',[0.1 0.9 0.1]);
text(winT(1,1), 0 , '|', 'FontSize',10,'FontWeight','bold',...
      'color',[0.1 0.9 0.1]);
text(winT(1,1)+0.002, -.35 , num2str(IntervalNeg2T), 'FontSize',10,...
      'FontWeight','bold', 'color',[0.1 0.9 0.1]);
text(winT(end,1), 0 , '|', 'FontSize',10,'FontWeight','bold',...
      'color',[0.1 0.9 0.1]);
text(winT(end,1)-0.02, -.35 , num2str(IntervalPos2T), 'FontSize',10,...
      'FontWeight','bold', 'color',[0.1 0.9 0.1]);

% text(0.02, 0.47, str, 'HorizontalAlignment','left') 
% text(-0.01, 0.5, ['File:' str0]);
text(0.6*winT(end,1), 0.8*maxTr, strT, 'HorizontalAlignment','left') 
text(0.9*winT(1,1), 0.9*maxTr, str0T);
axis tight
hold off

end
%%% end fig 1 
