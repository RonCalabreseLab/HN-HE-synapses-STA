function [sta_met, invCorrTrace, invTriggTrace, nDisFirst, nDisLast, ...
    intPosLocal, intNegLocal, intPos, intNeg, intPos2, intNeg2, ...
    intPSCNeg, isiBur, thre, pk, fract, corTrace, ct, calcMin, ...
    spikeSub, spikeAdd, over, dataNames, xLab, yl, yh, xLab1, yLab1, ...
    fontS, trPerPage, noBurStat, printNext] = askWinSTA_1_global(sigName)

sta_met = 0;
invCorrTrace = -1;
invTriggTrace = 1;
nDisFirst = 0;
nDisLast = 0; 

intPosLocal = 0.03;  %Window to detect minimum of IPSC after maximum
intNegLocal = 0.015; %0.015 for HN7/Window to detect minimum of IPSC before maximum
intPos = 0.45;  %%% ADM: this cannot be set up in the window
intNeg = 0.15;  %%% ADM: this cannot be set up in the window
intPos2 = 0.3;  %set delay here (for the individual spike triggered average sta_3)
intNeg2 = 0.05; %set delay here (for the individual spike triggered average sta_3)
intPSCNeg = 0.01;

isiBur = 1;
thre = 30;
pk = 250;
fract = 0.01;

corTrace = 0;
ct = corTrace;
calcMin = 0;
spikeSub = 10; 
spikeAdd = 10;

over = 0;% Overlay=1; to make it overlay with every trace
dataNames = 'Voltage';
xLab = 'Time,  [Sec]';
yl = -0.1; %minimum ipsc amplitude on the y-axis
yh = 0.2; %maximum ipsc amplitude on the y-axis
xLab1 = 'Delay, [sec]'; %x-axis label
yLab1 = 'I_{syn}, [nA]';
fontS = 6; %FontSize
trPerPage = 10;
noBurStat = 3;
printNext = 1;

%%% window to ask for deletion - if YES you can delete traces
figGlob = figure('position', [100 100 900 600],'Name','Input Globals',...
        'Toolbar','none','MenuBar','none', 'NumberTitle','off'); 
    set(gca,'Visible','off');    
    hold on;
    aa = ['                                                         '...
        '                                 GLOBALS for signal HN ' sigName...
        '                                                         ' ...
        '                                                         ' ];
    pFig = uipanel('Parent', figGlob,'Title', aa,...
        'Position',[.02 .02 .95 .95],'Visible','on');
    
    %%% general panel
    pGen = uipanel('Parent', pFig, 'Title','General data', ...
        'Position',[.015 .15 .495 .85],'Visible','on');
    staEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','0',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.21 .91 .05 .05],...
        'Callback',{@sta_callback});  
    staTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','STA_method = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .91 .2 .05]); 
    strAux = ['0=global sta/' '1=indiv sta/' ...
        '2=anal. med. spk +/- some spks'];
    staTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.28 .91 .7 .05]); 
    
    invCorrTrEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','-1',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.21 .85 .05 .05],...
        'Callback',{@invCorrTr_callback});  
    invCorrTrTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','invCorrTrace = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .85 .2 .05]); 
    strAux = 'Use -1 to invert the signal for the Correction Trace';
    invCorrTrTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.26 .85 .7 .05]); 
   
    invTriggTrEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','1',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.21 .79 .05 .05],...
        'Callback',{@invTriggTr_callback});  
    invTriggTrTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','invTriggTrace = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .79 .2 .05]); 
    strAux = 'Use -1 to invert the signal for the Triggering Trace';
    invTriggTrTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.26 .79 .7 .05]); 
       
    isiBurEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','1',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.21 .67 .05 .05],...
        'Callback',{@isiBur_callback});  
    isiBurTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','ISIburst = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .67 .2 .05]); 
    strAux = 'Determine minimum interburst interval in seconds';
    isiBurTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.26 .67 .7 .05]); 
    
    threEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','30',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.21 .61 .1 .05],...
        'Callback',{@thre_callback});  
    threTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','threshold = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .61 .2 .05]); 
    strAux = 'Signals above this level are spikes';
    threTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.31 .61 .6 .05]); 
    
    pkEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','250',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.21 .55 .1 .05],...
        'Callback',{@pk_callback});  
    pkTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','peak = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .55 .2 .05]); 
    strAux = 'Spikes above this level will not be detected';
    pkTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.31 .55 .6 .05]); 
    
    fractEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','0.01',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.18 .43 .08 .05],...
        'Callback',{@fract_callback});  
    fractTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','Trefractory = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .43 .17 .05]); 
    strAux = 'To avoid single spike detected twice in extracellular recording';
    fractTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.26 .43 .74 .05]); 
    
    corTraceEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','0',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.23 .37 .05 .05],...
        'Callback',{@corTrace_callback});  
    corTraceTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','CorrectionTrace = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .37 .22 .05]); 
    strAux = '1=yes / 0=no /-1 for 4 columns of data,no correct. trace';
    corTraceTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.28 .37 .72 .05]); 
    
    calcMinEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','0',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.17 .31 .05 .05],...
        'Callback',{@calcMin_callback});  
    calcMinTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','CalcMin = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .31 .15 .05]); 
    strAux = 'Calculate for EPSC: 1; for IPSC: 0';
    calcMinTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.23 .31 .4 .05]); 
 
    strAux = ['Number of first spikes in the burst to be discarded '...
        '... use STA =0 for it (Anca)'];
    spkText = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .19 .95 .05]); 
    strAux = ['Number of last spikes in the burst to be discarded '...
        '... use STA =0 for it (Anca)'];
    spkText = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .13 .95 .05]); 
    
    spikeSubEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','10',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.26 .07 .05 .05],...
        'Callback',{@spikeSub_callback});  
    spikeSubTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','spike_subtractor = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .07 .25 .05]); 
    strAux = 'number of spikes to subtract at the ends';
    spikeSubTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.31 .07 .52 .05]); 
    
    spikeAddEdit = uicontrol('Parent',pGen,...
        'Style','edit','String','10',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.26 .01 .05 .05],...
        'Callback',{@spikeAdd_callback});  
    spikeAddTextLeft = uicontrol('Parent',pGen,...
        'Style','text','String','spike_adder = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .01 .2 .05]); 
    strAux = 'number of spikes to add to the median spike';
    spikeAddTextRight = uicontrol('Parent',pGen,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.31 .01 .6 .05]); 
    
    %%% interval panel
    pInt = uipanel('Parent', pFig, 'Title','Interval data', ...
        'Position',[.52 .65 .47 .35],'Visible','on');
    intPosLocalEdit = uicontrol('Parent',pInt,...
        'Style','edit','String','0.03',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.25 .82 .1 .1],...
        'Callback',{@intPosLocal_callback});  
    intPosLocalTextLeft = uicontrol('Parent',pInt,...
        'Style','text','String','IntervalPosLocal = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .82 .24 .1]); 
    strAux = ['Window to detect minimum of IPSC after maximum'];
    intPosLocalTextRight = uicontrol('Parent',pInt,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.36 .82 .63 .1]);    
    
    intNegLocalEdit = uicontrol('Parent',pInt,...
        'Style','edit','String','0.015',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.25 .71 .1 .1],...
        'Callback',{@intNegLocal_callback});  
    intNegLocalTextLeft = uicontrol('Parent',pInt,...
        'Style','text','String','IntervalNegLocal = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .71 .24 .1]); 
    strAux = ['Window to detect minimum of IPSC before maximum'];
    intNegLocalTextRight = uicontrol('Parent',pInt,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.36 .71 .63 .1]);    
    
    intPosEdit = uicontrol('Parent',pInt,...
        'Style','edit','String','0.45',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.27 .49 .1 .1],...
        'Callback',{@intPos_callback});  
    intPosTextLeft = uicontrol('Parent',pInt,...
        'Style','text','String','IntervalPos = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .49 .2 .1]); 
    strAux = [' delay, use with STA = {1, 2}'];
    intPosTextRight = uicontrol('Parent',pInt,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.38 .49 .4 .1]);  
 
    intNegEdit = uicontrol('Parent',pInt,...
        'Style','edit','String','0.15',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.27 .38 .1 .1],...
        'Callback',{@intNeg_callback});  
    intNegTextLeft = uicontrol('Parent',pInt,...
        'Style','text','String','IntervalNeg = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .38 .2 .1]); 
    intNegTextRight = uicontrol('Parent',pInt,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.38 .38 .37 .1]);
    
    intPos2Edit = uicontrol('Parent',pInt,...
        'Style','edit','String','0.3',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.27 .27 .1 .1],...
        'Callback',{@intPos2_callback});  
    intPos2TextLeft = uicontrol('Parent',pInt,...
        'Style','text','String','IntervalPos2 = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .27 .22 .1]); 
    strAux = [' delay, use with STA = 0 (Anca)'];
    intPos2TextRight = uicontrol('Parent',pInt,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.38 .27 .4 .1]);  
 
    intNeg2Edit = uicontrol('Parent',pInt,...
        'Style','edit','String','0.05',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.27 .16 .1 .1],...
        'Callback',{@intNeg2_callback});  
    intNeg2TextLeft = uicontrol('Parent',pInt,...
        'Style','text','String','IntervalNeg2 = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .16 .22 .1]); 
    intNeg2TextRight = uicontrol('Parent',pInt,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.38 .16 .4 .1]);
 
    intPSCNegEdit = uicontrol('Parent',pInt,...
        'Style','edit','String','0.01',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.27 .05 .1 .1],...
        'Callback',{@intPSCNeg_callback});  
    intPSCNegTextLeft = uicontrol('Parent',pInt,...
        'Style','text','String','IntervalPSCNeg = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .05 .25 .1]); 
        
    %%% printing panel
    pPrint = uipanel('Parent', pFig, 'Title','Printing data', ...
        'Position',[.52 .01 .47 .6],'Visible','on');

    ylEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String', '-0.1',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.14 .91 .08 .06],...
        'Callback',{@yl_callback});  
    ylTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','yL = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .89 .12 .08]); 
    strAux = 'minimum IPSC amplitude on the y-axis';
    ylTextRight = uicontrol('Parent',pPrint,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.23 .89 .5 .08]);
    
    yhEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String', '0.2',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.14 .82 .08 .06],...
        'Callback',{@yh_callback});  
    yhTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','yH = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .8 .12 .08]); 
    strAux = 'maximum IPSC amplitude on the y-axis';
    yhTextRight = uicontrol('Parent',pPrint,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.23 .8 .5 .08]);

    overEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String', '0',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.14 .73 .05 .06],...
        'Callback',{@over_callback});  
    overTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','Overlay = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .71 .12 .08]); 
    strAux = 'Overlay=1 - to make it overlay with every trace';
    overTextRight = uicontrol('Parent',pPrint,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.2 .71 .6 .08]);
   
    dataNamesEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String', dataNames,...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.2 .55 .4 .06],...
        'Callback',{@dataNames_callback});  
    dataNamesTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','DataNames = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .53 .18 .08]); 
    
    xLabEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String', xLab,...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.14 .47 .4 .06],...
        'Callback',{@xLab_callback});  
    xLabTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','x_label = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .45 .12 .08]); 
    strAux = 'x-axis label on the spike plot';
    xLabTextRight = uicontrol('Parent',pPrint,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.55 .45 .4 .08]);
    
    xLab1Edit = uicontrol('Parent',pPrint,...
        'Style','edit','String', xLab1,...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.14 .39 .4 .06],...
        'Callback',{@xLab1_callback});  
    xLab1TextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','x_label = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .37 .12 .08]); 
    strAux = 'x-axis label';
    xLab1TextRight = uicontrol('Parent',pPrint,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.55 .37 .2 .08]);
    
    yLab1Edit = uicontrol('Parent',pPrint,...
        'Style','edit','String', yLab1,...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.14 .31 .4 .06],...
        'Callback',{@yLab1_callback});  
    yLab1TextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','y_label = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .29 .12 .08]); 
    strAux = 'y-axis label';
    yLab1TextRight = uicontrol('Parent',pPrint,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.55 .29 .2 .08]);
   
    fontSEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String','6',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.17 .22 .05 .06],...
        'Callback',{@fontS_callback});  
    fontSTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','FontSize = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .19 .15 .08]);

    trPerPageEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String','10',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.24 .16 .05 .06],...
        'Callback',{@trPerPage_callback});  
    trPerPageTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','TracesPerPage = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .13 .23 .08]); 
    
    noBurStatEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String','3',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.21 .1 .05 .06],...
        'Callback',{@noBurStat_callback});  
    noBurStatTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','NBurstsStat = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .07 .2 .08]); 

    printNextEdit = uicontrol('Parent',pPrint,...
        'Style','edit','String','1',...
        'Units','normalized',...
        'Enable','on',...
        'Position',[.16 .03 .05 .06],...
        'Callback',{@printNext_callback});  
    printNextTextLeft = uicontrol('Parent',pPrint,...
        'Style','text','String','PrintNext = ',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.01 .01 .15 .08]); 
    strAux = 'Every PrintNext will be printed on the figure';
    printNextTextRight = uicontrol('Parent',pPrint,...
        'Style','text','String', strAux,...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.21 .01 .6 .08]);
    
    
    submitBut = displaySubmitButton();      
    hold off;
    uiwait(figGlob);

function sta_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        staStr = get(staEdit, 'String');
        sta_met = str2num(staStr);
        %disp(['sta_method = ' staStr ' ...'])
end  
function invCorrTr_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(invCorrTrEdit, 'String');
        invCorrTrace = str2num(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end  
function invTriggTr_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(invTriggTrEdit, 'String');
        invTriggTrace = str2num(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function intPosLocal_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(intPosLocalEdit, 'String');
        intPosLocal = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function intNegLocal_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(intNegLocalEdit, 'String');
        intNegLocal = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function intPos_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(intPosEdit, 'String');
        intPos = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function intNeg_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(intNegEdit, 'String');
        intNeg = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function intPos2_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(intPos2Edit, 'String');
        intPos2 = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function intNeg2_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(intNeg2Edit, 'String');
        intNeg2 = str2double(invStr)
        %disp(['sta_method = ' staStr ' ...'])
end 
function intPSCNeg_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(intPSCNegEdit, 'String');
        intPSCNeg = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function isiBur_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(isiBurEdit, 'String');
        isiBur = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function thre_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(threEdit, 'String');
        thre = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function pk_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        invStr = get(pkEdit, 'String');
        pk = str2double(invStr);
        %disp(['sta_method = ' staStr ' ...'])
end 
function fract_callback(hObject,eventdata)  
        invStr = get(fractEdit, 'String');
        fract = str2double(invStr);
end 
function corTrace_callback(hObject,eventdata)  
        invStr = get(corTraceEdit, 'String');
        corTrace = str2num(invStr);
        ct = corTrace;
end 
function calcMin_callback(hObject,eventdata)  
        invStr = get(calcMinEdit, 'String');
        calcMin = str2num(invStr);
end 
function spikeSub_callback(hObject,eventdata)  
        invStr = get(spikeSubEdit, 'String');
        spikeSub = str2num(invStr);
end 
function spikeAdd_callback(hObject,eventdata)  
        invStr = get(spikeAddEdit, 'String');
        spikeAdd = str2num(invStr);
end 

function yl_callback(hObject,eventdata)  
        invStr = get(ylEdit, 'String');
        yl = str2double(invStr);
end 
function yh_callback(hObject,eventdata)  
        invStr = get(yhEdit, 'String');
        yh = str2double(invStr);
end 
function over_callback(hObject,eventdata)  
        invStr = get(overEdit, 'String');
        over = str2num(invStr);
end 
function dataNames_callback(hObject,eventdata)  
        dataNames = get(dataNamesEdit, 'String');
end 
function xLab_callback(hObject,eventdata)  
        xLab = get(xLabEdit, 'String');
end 
function xLab1_callback(hObject,eventdata)  
        xLab1 = get(xLab1Edit, 'String');
end 
function yLab1_callback(hObject,eventdata)  
        yLab1 = get(yLab1Edit, 'String');
end 
function fontS_callback(hObject,eventdata)  
        invStr = get(fontSEdit, 'String');
        fontS = str2num(invStr);
end 
function trPerPage_callback(hObject,eventdata)  
        invStr = get(trPerPageEdit, 'String');
        trPerPage = str2num(invStr);
end 
function noBurStat_callback(hObject,eventdata)  
        invStr = get(noBurStatEdit, 'String');
        noBurStat = str2num(invStr);
end 
function printNext_callback(hObject,eventdata)  
        invStr = get(printNextEdit, 'String');
        printNext = str2num(invStr);
end 

function sbBut = displaySubmitButton()
    sbBut = uicontrol(pFig, 'Style','pushbutton', ...
        'Units','normalized',...
        'String','Submit', ...
        'Position',[0.2 0.01 0.1 0.05], ...
        'Callback',{@submit_callback});  
 end
function submit_callback(hObject,eventdata)
  close all
end
    
end



