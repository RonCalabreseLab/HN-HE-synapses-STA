%Plot IPSCs TracesPerPage traces per page
function plotIPSCtracesPerPage(NNT, TracesPerPageT, PrintNextT, FntST, ...
    IntervalNeg2T, IntervalPos2T, wintT, winFT, MaxT, MinT, MaxNumT, ...
    MinNumT, goodSpFT)


numPages = ceil(NNT / (TracesPerPageT * PrintNextT));
trPP = TracesPerPageT + 1;
fign = 0;

xL2T = -IntervalNeg2T;
xR2T = IntervalPos2T;


for nP = 1:2:numPages
     fign = fign + 1;
     Fig = figure;
%      title('Individual Spike Triggered Average')
     set(gcf,'PaperUnits','centimeters','PaperPosition',[1.5 2 9 15])
     hFig = axes('Position',[0 0 1 1],'Visible','off');

     %ADM not used
%      if (nP * TracesPerPageT * PrintNextT > NNT)
%           nmum = NNT;
%      else
%           nmum = nP * TracesPerPageT;
%      end

     yL = min(MinT);
     yH = max(MaxT);
     %yH=MaxT(nmum);

     % Plot Left column on the page
     kk = 0;
     for NSpikeTrig = 1 + (nP-1) * TracesPerPageT * ...
             PrintNextT:PrintNextT:nP * TracesPerPageT * PrintNextT
          kk = kk + 1;
          if (NSpikeTrig > NNT)
               break;
          end
          axes('Position',[0.05 1.-kk/trPP .35 1/trPP],'Visible','off');
          plot(wintT, winFT(NSpikeTrig, :)); %prints spike number of burst
          hold on;
          plot(wintT(MaxNumT(NSpikeTrig)), MaxT(NSpikeTrig),'.g');
          plot(wintT(MinNumT(NSpikeTrig)), MinT(NSpikeTrig),'.g');
          plot([wintT(MaxNumT(NSpikeTrig)) wintT(MaxNumT(NSpikeTrig))], ...
              [MinT(NSpikeTrig) MaxT(NSpikeTrig)],'-g');
          text(1.05 * wintT(MaxNumT(NSpikeTrig)), 1.05 * MaxT(NSpikeTrig), ...
              num2str(wintT(MaxNumT(NSpikeTrig))),'FontSize',FntST, ...
              'FontWeight','normal','color',[0.2 0.5 0.3]);

          nSpiketxt = num2str(NSpikeTrig);
          ngSpiketxt = num2str(goodSpFT(NSpikeTrig));
          shftX = (xR2T - xL2T);
          shftY = (yH - yL) * 0.2;
          text(xL2T + shftX * 0.05, yH - shftY, nSpiketxt,'FontSize',FntST, ...
              'FontWeight','normal','color',[0.2 0.5 0.3]);
          text(xR2T - shftX * 0.25, yH - shftY, [ngSpiketxt ' bursts'], ...
              'FontSize',FntST,'FontWeight','normal','color',[0.2 0.5 0.3]);
          set(gca,'Visible','off');
          axis([xL2T xR2T yL yH]);
     end
     set(gca,'Visible','off','Box','off','FontSize',10,'FontWeight','normal');
     xlabel('Time (sec)');
     ylabel('IPSC [nA]');
  
     %ADM not used
%      if (nP+1)*TracesPerPageT>NNT
%           nmum=NNT;
%      else
%           nmum=(nP+1)*TracesPerPageT;
%      end

   % Plot Right column on the page
     kk=0;
     for NSpikeTrig = 1 + nP * TracesPerPageT * ...
             PrintNextT:PrintNextT:(nP+1) * TracesPerPageT * PrintNextT
          kk = kk + 1;
          if (NSpikeTrig > NNT)
               break;
          end
          axes('Position',[0.55 1.-kk/trPP .35 1/trPP],'Visible','off');
          plot(wintT, winFT(NSpikeTrig,:));
          hold on;
          plot(wintT(MaxNumT(NSpikeTrig)), MaxT(NSpikeTrig),'.g');
          plot(wintT(MinNumT(NSpikeTrig)), MinT(NSpikeTrig),'.g');
          plot([wintT(MaxNumT(NSpikeTrig)) wintT(MaxNumT(NSpikeTrig))], ...
              [MinT(NSpikeTrig) MaxT(NSpikeTrig)],'-g');
          text(1.05 * wintT(MaxNumT(NSpikeTrig)), 1.05 * MaxT(NSpikeTrig), ...
              num2str(wintT(MaxNumT(NSpikeTrig))),'FontSize', FntST, ...
              'FontWeight','normal','color',[0.2 0.5 0.3]);

          nSpiketxt = num2str(NSpikeTrig);
          ngSpiketxt = num2str(goodSpFT(NSpikeTrig));
          shftX = (xR2T - xL2T);
          shftY = (yH - yL) * 0.2;
          text(xL2T + shftX * 0.05, yH - shftY, nSpiketxt,'FontSize',FntST, ...
              'FontWeight','normal','color',[0.2 0.5 0.3]);
          text(xR2T - shftX * 0.15, yH - shftY, [ngSpiketxt ' bursts'], ...
              'FontSize',FntST,'FontWeight','normal','color',[0.2 0.5 0.3]);
          set(gca,'Visible','off');
          axis([xL2T xR2T yL yH]);
     end
     set(gca,'Visible','off','Box','off','FontSize',10,'FontWeight','normal');
     xlabel('Time (sec)');
     ylabel('IPSC [nA]');
     nm = num2str(fign);
end

end