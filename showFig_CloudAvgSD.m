function [idxXleft, idxXright] = showFig_CloudAvgSD(figName, sta_methodT, traces, winT, avgTr, ...
    stdT, NPointsWinNegLocalT, maxIPSC, maxIPSCNN, minIPSC, minIPSCNN, ...
    maxNegIPSC, maxNegIPSCNN, maxPosIPSC, maxPosIPSCNN, minNegIPSC, ...
    minNegIPSCNN, minPosIPSC, minPosIPSCNN, IntervalNeg2T, IntervalPos2T,...
    CalcMinT, str0T, strT, xlabel1T, ylabel1T, ...
    c_ampL, c_ampR, c_stdL, c_stdR)

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
%axis tight

idxXleft = 0;
idxXright = 0;
CalcMinT
if CalcMinT == 0
    if (maxIPSCNN - NPointsWinNegLocalT > 0)
        plot(ax, winT(maxIPSCNN - NPointsWinNegLocalT + minNegIPSCNN - 1),...
             minNegIPSC,'+ y');
        idxXleft = maxIPSCNN - NPointsWinNegLocalT + minNegIPSCNN - 1
    else
        plot(ax, winT(minNegIPSCNN), minNegIPSC,'+ y');
        idxXleft = minNegIPSCNN
    end
    plot(ax, winT(maxIPSCNN + minPosIPSCNN - 1), minPosIPSC,'+ y');
    plot(ax, winT(maxIPSCNN), maxIPSC, '+ y');
    maxIPSCNN
    idxXright = maxIPSCNN + minPosIPSCNN - 1

else
    if (minIPSCNN - NPointsWinNegLocalT >0)
        plot(ax, winT(minIPSCNN - NPointsWinNegLocalT + maxNegIPSCNN - 1), ...
            maxNegIPSC,'+ y');
        idxXleft = minIPSCNN - NPointsWinNegLocalT + maxNegIPSCNN - 1
    else
        plot(ax, winT(minIPSCNN + maxNegIPSCNN - 1), ...
            maxNegIPSC,'+ y');
        idxXleft = minIPSCNN + maxNegIPSCNN - 1
    end
    plot(ax, winT(minIPSCNN + maxPosIPSCNN - 1), maxPosIPSC,'+ y');
    plot(ax, winT(minIPSCNN), minIPSC, '+ y');
    minIPSCNN
    idxXright = minIPSCNN + maxPosIPSCNN - 1

end

% idxXleft
% idxXright

%stdT(idxXleft:idxXright,1)
hold on
% errorbar shows SED, we want +/-SD
% sss = stdT(idxXleft:idxXright)/100;
% herr = errorbar(winT(idxXleft:idxXright), avgTr(idxXleft:idxXright), ...
%     sss, 'xc')
reducedSTD = stdT(idxXleft:idxXright);
disp(['reduced STDs # = ' num2str(size(reducedSTD))])
%set(herr, 'XData', idxXleft:idxXright)

%        %h3=plot(wintT,HNMean,'y-');
plot(ax, winT(idxXleft:idxXright), avgTr(idxXleft:idxXright,1) + ...
    stdT(idxXleft:idxXright,1), '+ c'); 
plot(ax, winT(idxXleft:idxXright), avgTr(idxXleft:idxXright,1) - ...
    stdT(idxXleft:idxXright,1), '+ c');

% plot(ax, c_ampL, 'o m');
% plot(ax, c_ampR, 'o m');
% plot(ax, c_stdL, 'o m');
% plot(ax, c_stdR, 'o m');
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
strTT = [];
strTT{1} = strT{1};  
strTT{2} = strT{2};  
strTT{3} = strT{3};  
strTT{4} = strT{4};  
strTT{5} = strT{5};  
strTT{6} = strT{6};  
strC = [];
strC{1} = strT{7};
strC{2} = strT{8};
strC{3} = strT{9};
strC{4} = strT{10};


% text(0.02, 0.47, str, 'HorizontalAlignment','left') 
% text(-0.01, 0.5, ['File:' str0]);
text(0.6*winT(end,1), 0.8*maxTr, strTT, 'HorizontalAlignment','left') 
text(0.9*winT(1,1), 0.9*maxTr, str0T);
text(0.6*winT(end,1), -0.8*maxTr, strC, 'HorizontalAlignment','left') 
axis tight
hold off

end
%%% end fig 1 
