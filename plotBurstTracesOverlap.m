%Plot overlap IPSCs traces per burst per page
function plotBurstTracesOverlap(postTraces, ...
    IntervalNeg2T, IntervalPos2T,...
    MaxT, MinT, wintT, FntST)

numPages = length(postTraces);
delTr = 0;
xL2T = -IntervalNeg2T;
xR2T = IntervalPos2T;
%xx = (xR2T - xL2T)*10000

set(0,'Units','pixels')
scnsize = get(0,'ScreenSize');
borders = [ -8    -8    16    86];%outerpos - position
figH = scnsize(4)-borders(4)-300;
panelH = 0.97;
s2 = 0.95;
ax2num = 0.03;
xx = scnsize(3) - 20;

for nP = 1:numPages % plot one burst (its traces) per one page
     [pointsTr, numTr] = size(postTraces{nP});
     auxBurstMatr = postTraces{nP};
            
     yL = min(min(auxBurstMatr));
     yH = max(max(auxBurstMatr));
     fprintf('Burst %d with %d traces', nP, numTr);
         
     %%%%%%%%%%
     figName = ['Burst: ' num2str(nP)];
     fign(1,nP) = figure('position', [10 200 xx figH],'Name',figName,...
         'Toolbar','figure','MenuBar','none', 'NumberTitle','off'); 
     %set(gca,'Visible','off');    
     hold on

     titlePanelBurst = num2str(nP);
     figPanel = uipanel('Title',titlePanelBurst,'FontSize',12,...
                 'Position',[.02 .005 .97 panelH]);
     pos = get(figPanel,'Position');
     ax = axes('Parent', figPanel,'Position',[0.03 ax2num .95 s2]);%,...
              %'Visible','off');
     
     for NSpikeTrig = 1:numTr
  
%           trMin = min(auxBurstMatr(:,NSpikeTrig))
%           trMax = max(auxBurstMatr(:,NSpikeTrig))
%           trWin = trMin + trMax + 1

          px = plot(ax, wintT, auxBurstMatr(:,NSpikeTrig)); %prints spike number of burst
          hold on;          
 
          shftX = (xR2T - xL2T);
          shftY = (yH - yL) * 0.2;
          text(0, 0 , '|', 'FontSize',12,'FontWeight','bold',...
              'color',[0.1 0.9 0.1]);
          text(0, -.3, '0', 'FontSize',11,'FontWeight','bold',...
              'color',[0.1 0.9 0.1]);
          text(wintT(1,1), 0 , '|', 'FontSize',12,'FontWeight','bold',...
              'color',[0.1 0.9 0.1]);
          text(wintT(1,1), -.3 , num2str(IntervalNeg2T), 'FontSize',11,...
              'FontWeight','bold', 'color',[0.1 0.9 0.1]);
          % to keep the timestep - the interval gets shifted a bit
%           text(wintT(1,1), 0 , '|', 'FontSize',FntST,'FontWeight','bold',...
%               'color',[0.1 0.9 0.1]);
%           text(wintT(1,1), -.3 , num2str(wintT(1,1)), 'FontSize',FntST,'FontWeight','bold',...
%               'color',[0.1 0.9 0.1]);
          text(wintT(end,1), 0 , '|', 'FontSize',12,'FontWeight','bold',...
              'color',[0.1 0.9 0.1]);
          text(wintT(end,1)-0.002, -.3 , num2str(IntervalPos2T), 'FontSize',11,...
              'FontWeight','bold', 'color',[0.1 0.9 0.1]);
          set(gca,'Visible','off');
          axis([xL2T xR2T yL yH]);
          axis on
          %fprintf('spk = %d ...', NSpikeTrig);
     end
     
     %%% plot the avg trace of the burst
     avgTrace = sum(auxBurstMatr,2) / numTr;
     ax = axes('Parent', figPanel,'Position',[0.03 ax2num .95 s2],...
              'Visible','on');
     px = plot(ax, wintT, avgTrace); %prints spike number of burst
     hold on; 
     set(px,'Color','red','LineWidth',2)
     %set(gca,'Visible','off');
     axis([xL2T xR2T yL yH]);
          
     fprintf('\n');
     set(gca,'Visible','off','Box','off','FontSize',10,'FontWeight','normal');
     xlabel('Time (sec)');
     ylabel('IPSC [nA]');
     hold off;
end

% NEW WINDOW FOR A CLOSE ALL FIGS BUTTON
% figDelTr = figure('position', [1300 400 200 200],'Name','Close',...
%          'Toolbar','none','MenuBar','none', 'NumberTitle','off'); 
% set(gca,'Visible','off');    
% hold on;
% set(figDelTr,'Units','normalized')
% pfig = uipanel('Position',[.02 .02 .97 .97]);
% submitBut = displaySubmitButton();
% hold off;
% 
% 
% % FUNCTIONS
% function sbBut = displaySubmitButton()
% sbBut = uicontrol(pfig, 'Style','pushbutton', ...
%     'Units','normalized',...
%     'String','CloseAll', ...
%     'Position',[0.3 0.3 0.5 0.3], ...
%     'Callback',{@submit_callback});  
% 
% end
% function submit_callback(hObject,eventdata)
%   close all
%   
% end

end


