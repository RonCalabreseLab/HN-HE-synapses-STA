function plotSpkTrigAvgCloud_1(winT, traces, fileName, IntervalNegLocalT, ...
    IntervalPosLocalT, sta_methodT, CalcMinT,  yHT, yLT, xlabel1T, ...
    ylabel1T, IntervalNegT, IntervalPosT)

%get num traces in each burst - keep (1,noTr) on each burst; a trace not
%existing in a burst is replaced by a vector of 0s
noTr = 0; %max num of traces to keep
aux = []; % real num of traces in each burst
lenTr = length(traces);
for ii = 1: lenTr
    [row, col] = size(traces{ii});
    aux(1,ii) = col; 
end
noTr = max(aux);

%noTr of vectors; each vector i has the info of each trace i from all bursts 
newTraces = zeros(length(winT)*lenTr, noTr);
auxSum = zeros(length(winT)*lenTr,1);
auxNo = zeros(length(winT)*lenTr,1);
for ii = 1:lenTr
    vv = traces{ii};
    [rr,cc] = size(vv); 
    left = (ii-1)*length(winT) + 1;
    right = ii*length(winT);
    for jj = 1:noTr
        if jj <= cc
            newTraces(left:right,jj) = vv(:,jj);
            auxSum(left:right,1) = auxSum(left:right,1) + vv(:,jj);
            auxNo(left:right,1) = auxNo(left:right,1) + 1;
        end
    end
end
%size(newTraces)
disp('.............stop here ...........')
goodSp = noTr;
%avgTr = sum(newTraces,2)./noTr;
avgTr = auxSum ./ auxNo;

ff = figure('Name', 'SpkTrigAvg Cloud', 'NumberTitle','off', ...
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
ax = axes('Parent', figPanel,'Position',[0.1 0.1 .85 .85]);
 
%wintT = (-NPointsWinNeg*timestep:timestep:(NPointsWinPos-1)*timestep)';
timestep = winT(2,1) - winT(1,1)
newWinT = (winT(1,1)*lenTr:timestep:winT(end,1)*lenTr + timestep*(lenTr-1))';
%size(newWinT)
for ii = 1:noTr
   px = plot(ax, newWinT, newTraces(:,ii), 'b');
   hold on;
end

pxx = plot(ax, newWinT, avgTr, 'r', 'LineWidth', 2);
%set(hff,'LineWidth',2);
hold on

NPointsWinNegLocalT = round(IntervalNegLocalT/timestep)
NPointsWinPosLocalT = round(IntervalPosLocalT/timestep)

[maxIPSC maxIPSCNN] = max(avgTr)
[minIPSC minIPSCNN] = min(avgTr)
 
if (minIPSCNN - NPointsWinNegLocalT > 0)
    [maxNegIPSC maxNegIPSCNN] = max(avgTr(minIPSCNN - NPointsWinNegLocalT:minIPSCNN))
else
    [maxNegIPSC maxNegIPSCNN] = max(avgTr(1:minIPSCNN))
end
     
if(minIPSCNN + NPointsWinPosLocalT) > length(avgTr)
     [maxPosIPSC maxPosIPSCNN] = max(avgTr(minIPSCNN:end))
else
     [maxPosIPSC maxPosIPSCNN] = max(avgTr(minIPSCNN:minIPSCNN + NPointsWinPosLocalT))
end
     
if (maxIPSCNN - NPointsWinNegLocalT > 0)
    [minNegIPSC minNegIPSCNN] = min(avgTr(maxIPSCNN - NPointsWinNegLocalT:maxIPSCNN))
else
    [minNegIPSC minNegIPSCNN] = min(avgTr(1:maxIPSCNN))
end

if ((maxIPSCNN + NPointsWinPosLocalT) > length(avgTr))
    [minPosIPSC minPosIPSCNN] = min(avgTr(maxIPSCNN:end))
else
    [minPosIPSC minPosIPSCNN] = min(avgTr(maxIPSCNN:maxIPSCNN + NPointsWinPosLocalT))
end

%%% these are really not useful !!!
xLT = -IntervalNegT;
xRT = IntervalPosT;
%yLT
%yHT

if CalcMinT == 0
    if (maxIPSCNN - NPointsWinNegLocalT > 0)
        plot(ax, newWinT(maxIPSCNN - NPointsWinNegLocalT + minNegIPSCNN - 1),...
             minNegIPSC,'+ y');
    else
        plot(ax, newWinT(minNegIPSCNN), minNegIPSC,'+ y');
    end
        %plot(ax, newWinT(maxIPSCNN - NPointsWinNegLocalT + minNegIPSCNN - 1),...
        %     minNegIPSC,'+ y');
        plot(ax, newWinT(maxIPSCNN + minPosIPSCNN - 1), minPosIPSC,'+ y');
        plot(ax, newWinT(maxIPSCNN), maxIPSC, '+ y');

else
     if (minIPSCNN - NPointsWinNegLocalT >0)
        plot(ax, newWinT(minIPSCNN - NPointsWinNegLocalT + maxNegIPSCNN - 1), ...
            maxNegIPSC,'+ y');
    else
        plot(ax, newWinT(minIPSCNN + maxNegIPSCNN - 1), ...
            maxNegIPSC,'+ y');
    end
        %plot(ax, newWinT(minIPSCNN - NPointsWinNegLocalT + maxNegIPSCNN - 1), ...
        %    maxNegIPSC,'+ y');
        plot(ax, newWinT(minIPSCNN + maxPosIPSCNN - 1), maxPosIPSC,'+ y');
        plot(ax, newWinT(minIPSCNN), minIPSC, '+ y');

end

%        %h3=plot(wintT,HNMean,'y-');
hold on
xlabel(xlabel1T);
ylabel(ylabel1T);
%axis([xLT xRT yLT yHT]);
axis tight
hold off

if CalcMinT == 0
        str{1} = ['AmpR= ' num2str(maxIPSC - minPosIPSC)];
        %text(0.05, 0.5, ['AmpR= ' str]);
        str{2} = ['AmpL= ' num2str(maxIPSC - minNegIPSC)];
        %text(0.6 * xRT, 0.6 * yHT, ['AmpL= ' str]);
        str{3} = ['Maximum at ' num2str(newWinT(maxIPSCNN))];
        %text(0.6 * xRT, 0.5 * yHT, ['Maximum at ' str]);
        str{4} = ['# of Spikes used = ' num2str(sum(aux))];
        %text(0.6 * xRT, 0.4 * yHT, ['# of Spikes used = ' str]);
else
        str{1} = ['AmpR= ' num2str(maxPosIPSC - minIPSC)];
        %text(0.6 * xRT, 0.7 * yHT, ['AmpR= ' str]);
        str{2} = ['AmpL= ' num2str(maxNegIPSC - minIPSC)];
        %text(0.6 * xRT, 0.6 * yHT, ['AmpL= ' str]);
        str{3} = ['Minimum at ' num2str(newWinT(minIPSCNN))];
        %text(0.6 * xRT, 0.5 * yHT, ['Minimum at ' str]);
        str{4} = ['# of Spikes used = ' num2str(sum(aux))];
        %text(0.6 * xRT, 0.4 * yHT, ['# of Spikes used = ' str]);   
end

text(0.2, 0.47, str, 'HorizontalAlignment','left') 
str = num2str(fileName);
text(-0.1, 0.5, ['File:' str]);
  end