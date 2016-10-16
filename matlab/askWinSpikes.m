function [flag, spkLeft, spkRight] = askWinSpikes(num)

spkLeft = 0;
spkRight = 0;
flag = -1; %default, do not remove anything
%%% window to ask for deletion - if YES you can delete traces
    figSpk = figure('position', [300 300 400 300],'Name','Spikes To Keep',...
        'Toolbar','none','MenuBar','none', 'NumberTitle','off'); 
    set(gca,'Visible','off');    
    hold on;
    set(figSpk,'Units','normalized')
    pfig = uipanel('Position',[.02 .02 .95 .95],'Visible','on');
    butName = ['Select spikes now - cumulative max ' num2str(num) ' spikes'];

    butGr = uibuttongroup('Parent',pfig,...
              'Title', butName,'Visible','on',...
              'BorderType', 'none', ...
              'Position',[.09 .09 0.9 0.9],...
              'SelectionChangeFcn',{@butGroup_callback});
    yesBut = uicontrol(butGr,'Style','radiobutton',...
              'String','Remove spikes from beginning and end of burst)',...
              'Tag','Yes',...
              'Units','normalized',...
              'Value',0,...
              'Position',[.05 .8 .9 .07]);
    noBut = uicontrol(butGr,'Style','radiobutton',...
              'String','Keep spikes from middle spike to the left and right)',...
              'Tag','No',...
              'Units','normalized',...
              'Value',0,...
              'Position',[.05 .4 .9 .07]);
    defBut = uicontrol(butGr,'Style','radiobutton',...
              'String','Keep ALL spikes',...
              'Tag','No',...
              'Units','normalized',...
              'Value',1,...
              'Position',[.05 .1 .9 .07]);
    yesEditLeft = uicontrol('Parent',pfig,...
        'Style','edit','String','',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.25 .6 .2 .05],...
        'Callback',{@yesLeft_callback});   
    yesTextLeft = uicontrol('Parent',pfig,...
        'Style','text','String','Left',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.25 .65 .2 .05]);  
    yesEditRight = uicontrol('Parent',pfig,...
        'Style','edit','String','',...
        'Units','normalized',...
        'Enable','off',...
        'Position',[.5 .6 .2 .05],...
        'Callback',{@yesRight_callback});   
    yesTextRight = uicontrol('Parent',pfig,...
        'Style','text','String','Right',...
        'Units','normalized',...
        'Position',[.5 .65 .2 .05]);
    
    noEditLeft = uicontrol('Parent',pfig,...
        'Style','edit','String','',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.25 .25 .2 .05],...
        'Callback',{@noLeft_callback});   
    noTextLeft = uicontrol('Parent',pfig,...
        'Style','text','String','Left',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.25 .3 .2 .05]);  
    noEditRight = uicontrol('Parent',pfig,...
        'Style','edit','String','',...
        'Units','normalized',...
        'Enable','inactive',...
        'Position',[.5 .25 .2 .05],...
        'Callback',{@noRight_callback});   
    noTextRight = uicontrol('Parent',pfig,...
        'Style','text','String','Right',...
        'Units','normalized',...
        'Position',[.5 .3 .2 .05]);
    submitBut = displaySubmitButton();      
    hold off;
    uiwait(figSpk);

function yesLeft_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        spkLeft = str2num(get(yesEditLeft, 'String'));
        disp(['yes L: ' num2str(spkLeft) ' ...'])
end   
function yesRight_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        spkRight = str2num(get(yesEditRight, 'String'));
        disp(['yes R: ' num2str(spkRight) ' ...'])
end
function noLeft_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        spkLeft = str2num(get(noEditLeft, 'String'));
        disp(['yes L: ' num2str(spkLeft) ' ...'])
end   
function noRight_callback(hObject,eventdata)  
        %switch get(eventdata.NewValue,'String') % Get String of selected object.
        spkRight = str2num(get(noEditRight, 'String'));
        disp(['yes R: ' num2str(spkRight) ' ...'])
end
function butGroup_callback(hObject,eventdata)  
        switch get(eventdata.NewValue,'Tag') % Get String of selected object.
            case 'Yes'  %move on - set it up to 1
                flag = 1;
                disp('Starting to Remove spikes from beginning and end of bursts !!!')
                set(yesEditLeft,'Enable','on')
                set(yesEditRight,'Enable','on')
                
            case 'No' %remove it from deletion - set it up to 0                                  
                disp('Starting to Keep spikes from middle spike to the left and right !!!')
                flag = 0;
                set(noEditLeft,'Enable','on')
                set(noEditRight,'Enable','on')
            case 'DEFAULT' % default flag = -1, do not remove; not tested
                flag = -1;
        end   
end
function sbBut = displaySubmitButton()
sbBut = uicontrol(pfig, 'Style','pushbutton', ...
    'Units','normalized',...
    'String','Submit', ...
    'Position',[0.25 0.03 0.5 0.1], ...
    'Callback',{@submit_callback});  

end
function submit_callback(hObject,eventdata)
  
%   flag
%   spkLeft
%   spkRight
  close all
  
end
end