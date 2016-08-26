%Plot IPSCs TracesPerPage traces per page
function [deleteTraces, figDONE] = plotBurstTraces(postTraces, ...
    IntervalNeg2T, IntervalPos2T, MaxT, MinT, wintT, FntST)

numPages = length(postTraces);
% TracesPerPageT = number of spikes in each burst; one burst per page
deleteTraces = cell(1,numPages);%size(postTraces));
tracesToRemove = cell(1,numPages);
%size(deleteTraces)

%fign = 0;
xL2T = -IntervalNeg2T;
xR2T = IntervalPos2T;
%size(wintT)
%xx = (xR2T - xL2T)*8000;% was =  * 10000 + 200;

set(0,'Units','pixels')
scnsize = get(0,'ScreenSize');
borders = [ -8    -8    16    86];%outerpos - position
figH = scnsize(4)-borders(4)-10;
%was: trPP = numTr + 1; --- too small, fitting all in the visible window
trPP = 15; %num of visible traces on screen without scrolling
figPanel = [];
fign = [];
activePgToUpdate = 0;
xx = scnsize(3) - 20;

for nP = 1:numPages % plot one burst (its traces) per one page
     [pointsTr, numTr] = size(postTraces{nP});
     numTrP = numTr + 1; % +1 to be able to see the 1st one on the panel
     auxBurstMatr = postTraces{nP};
     panelH =  numTrP / trPP + 1;
     s2 = 1/numTrP;
     
     yL = min(min(auxBurstMatr));
     yH = max(max(auxBurstMatr));
     fprintf('Burst %d with %d traces \n', nP, numTr);
     kk = 1;
     
     %%%%%%%%%%
     figName = ['Burst: ' num2str(nP)];
     fign(1,nP) = figure('position', [10 40 xx figH],'Name',figName,...
         'Toolbar','figure','MenuBar','none', 'NumberTitle','off'); 
     %set(gca,'Visible','off');    
     hold on

     titlePanelBurst = num2str(nP);
     figPanel(1,nP) = uipanel('Title',titlePanelBurst,'FontSize',12,...
                 'Position',[.02 .005 .96 panelH]);
     %pos = get(figPanel(1,nP),'Position');
     scrollCtrl = displaySlider(numTrP); %get a slider
     %pos = get(scrollCtrl,'Position');
     %submitBut = displaySubmitButton();
     butGroup = [];
     tracesToRemove{1,nP} = zeros(numTr,1); %start with 0; if "yes" gets set up 1
     rightBorder = IntervalPos2T - 1/9.9000e-005; % the timestep
     
     for NSpikeTrig = 1:numTr
          kk = kk + 1;
          
%           trMin = min(auxBurstMatr(:,NSpikeTrig))
%           trMax = max(auxBurstMatr(:,NSpikeTrig))
%           trWin = trMin + trMax + 1

          ax2num = 1-kk/numTrP;
          ax = axes('Parent', figPanel(1,nP), 'Position',[0.03 ax2num .86 s2]);%,...
              %'Visible','off');
          
          px = plot(ax, wintT, auxBurstMatr(:,NSpikeTrig)); %prints spike number of burst
          hold on;
  
          nSpiketxt = num2str(NSpikeTrig);
          butName = ['Remove ' num2str(nSpiketxt) '?'];
          labelBut = uicontrol('Parent',figPanel(1,nP),...
              'Style','text',...
              'Units','normalized',...
              'String',butName,...
              'Position',[.9 ax2num .08 s2*0.7]); %-0.005
          butGroup(1, NSpikeTrig) = uibuttongroup('Parent',figPanel(1,nP),...
              'BorderType', 'none', ...
              'Position',[.92 ax2num-0.001 .08 s2*0.8],...
              'SelectionChangeFcn',{@butGroup_callback, NSpikeTrig});
          yesBut = uicontrol(butGroup(1, NSpikeTrig),'Style','radiobutton',...
              'String','Yes',...
              'Units','normalized',...
              'Value',0,...
              'Position',[.05 .2 .3 .5]);
          noBut = uicontrol(butGroup(1, NSpikeTrig),'Style','radiobutton',...
              'String','No',...
              'Units','normalized',...
              'Value',1,...
              'Position',[.35 .2 .3 .5]);

%           ngSpiketxt = num2str(goodSpFT(NSpikeTrig));
          shftX = (xR2T - xL2T);
          shftY = (yH - yL) * 0.2;
          text(xL2T + shftX * 0.05, yH - shftY, nSpiketxt,'FontSize',FntST, ...
               'FontWeight','normal','color',[0.2 0.5 0.3]);
          text(0, 0 , '|', 'FontSize',10,'FontWeight','bold',...
              'color',[0.1 0.9 0.1]);
          text(0, -.3, '0', 'FontSize',10,'FontWeight','bold',...
              'color',[0.1 0.9 0.1]);
          text(wintT(1,1), 0 , '|', 'FontSize',10,'FontWeight','bold',...
              'color',[0.1 0.9 0.1]);
          text(wintT(1,1), -.3 , num2str(IntervalNeg2T), 'FontSize',10,...
              'FontWeight','bold', 'color',[0.1 0.9 0.1]);
          text(wintT(end,1), 0 , '|', 'FontSize',10,'FontWeight','bold',...
              'color',[0.1 0.9 0.1]);
          text(wintT(end,1)-0.002, -.3 , num2str(IntervalPos2T), 'FontSize',10,...
              'FontWeight','bold', 'color',[0.1 0.9 0.1]);
          %%%% uncomment next line to not see axis on each trace
          %set(gca,'Visible','off');
          axis([xL2T xR2T yL yH]);

          %fprintf('spk = %d ...', NSpikeTrig);
     end
     
     %disp(['borders...' num2str(wintT(1,1)) '-' num2str(wintT(end,1))])
     %disp(['borders...' num2str(-IntervalNeg2T) '-' num2str(IntervalPos2T)])
     %fprintf('\n');
     set(gca,'Visible','off','Box','off','FontSize',10,'FontWeight','normal');
     xlabel('Time (sec)');
     ylabel('IPSC [nA]');
     hold off;
   
end

% NEW WINDOW FOR A CLOSE ALL FIGS BUTTON
figDONE = figure('position', [20 700 200 200],'Name','OK',...
         'Toolbar','none','MenuBar','none', 'NumberTitle','off'); 
set(gca,'Visible','off');    
hold on;
pfig = uipanel('Position',[.02 .02 .97 .97]);
submitBut = displaySubmitButton();
hold off;
uiwait(figDONE);

% FUNCTIONS
function butGroup_callback(hObject,eventdata, nSpk)
 
    activePgToUpdate = get(get(hObject,'Parent'),'Title'); %global to  
            %be used to update the correct cell of deleteTraces; gives the 
            %page no. or the index of the cell
    actPg = str2num(activePgToUpdate);
    prevTraces = tracesToRemove{1,actPg};
    
    switch get(eventdata.NewValue,'String') % Get String of selected object.
        case 'Yes'  %move on - set it up to 1
              
            if prevTraces(nSpk,1) == 0
                 prevTraces(nSpk,1) = 1;
                 tracesToRemove{1,actPg} = prevTraces;
            end %otherwise it is already set up
                                       
            disp(['EVENT: Trace ' num2str(nSpk) ' to delete!!!'])
                
        case 'No' %remove it from deletion - set it up to 0
            if prevTraces(nSpk,1) == 1
                 prevTraces(nSpk,1) = 0;
                 tracesToRemove{1,actPg} = prevTraces;
            end %otherwise it is already set up
                                       
            disp(['EVENT: Trace ' num2str(nSpk) ' to NOT delete!!!'])           
    end   
end
function sbBut = displaySubmitButton()
sbBut = uicontrol(pfig, 'Style','pushbutton', ...
    'Units','normalized',...
    'String','Submit', ...
    'Position',[0.3 0.3 0.5 0.3], ...
    'Callback',{@submit_callback});%, butGroup(1,NSpikeTrig)})  

end
function submit_callback(hObject,eventdata)
   disp('List of traces to be deleted: ')
   for i = 1:numPages
       strTr = [];
       deleteTraces{1,i} = find(tracesToRemove{1,i} > 0);%tracesToRemove
       if length(deleteTraces{1,i})>0
            for jj=1:length(deleteTraces{1,i})
                aa = deleteTraces{1,i};
                strTr = [strTr '_' num2str(aa(jj))];
            end
            disp(['Burst ' num2str(i) ' traces to del ' strTr])
       end
   end
   %deleteTraces
   close(figDONE)
end
function hslider = displaySlider(~)
%slider 
if (numTrP < trPP),
  sliderEnable = 'off';
else
  sliderEnable = 'on';
end
mm = max(numTrP, 1);

hslider = uicontrol('style','slider',...
                   'units','pixels',...
                   'position',[10 2 10 figH], ... 
                   'backgroundcolor','w',...
                   'min',1,'max',mm,...
                   'SliderStep', [1 1]./mm, ...
                   'Value', 1, ...
                   'enable',sliderEnable,...
                   'CallBack', {@getScroll,figPanel(1,nP)});
end
function getScroll(h, eventdata, handles)
    % The Max and Min properties specify the slider's maximum and minimum
    % values. The slider's range is Max - Min. 
    %get(h, 'Parent') = same as handles, the parent uipanel
    val = get(h,'Value');
    panelPos = get(handles,'Position');
    panelPos(2) = -(panelH - 1) * (val - 1)/numTrP;
    set(handles,'Position', panelPos);
    %pos = get(handles,'Position')
end


end


% function submit_callback(hObject,eventdata, handles)
% % selName = get(get(butGroup, 'SelectedObject'), 'String')
% selVal = get(handles, 'Value')
% selMax = get(handles, 'Max')
% % if (get(hObject,'Value') == get(hObject,'Max'))
% %  % Radio button is selected-take approriate action
% %  v1 = get(hObject, 'String');
% %  gg = ['Trace ' v1 ' was changed to be REMOVED!'];
% %  disp(gg);
% % else
% %  % Radio button is not selected-take approriate action
% % end
% end