%%% 21 October 2011 - Anca Doloc-Mihu
%%% 
%%% Code from Mike (MTW) with STA analysis was modified by ADM.
%%% 
%%% To run it >startSpkTrigAvgAnalysis
%%% 

%%% Features added (used STA = 0 for Anca's code):
%%% 0) No global variables. Used functions. Global data for each signal can
%%% be given now via a windows. This way we allow for eg., to change the 
%%% threshold value (time window) for each channel according to data.
%%%
%%% 1) Read 1 to 4 pre signals from file. And work with each one of them.
%%% Write their resulted data in a corresponding file. After all signals
%%% are done, write a file with all signals. This file can be used again
%%% with the code. Warning: file name convention (must be used!!!) -
%%% HN####toHE##_date.atf, where # is the signal number. There must be 2 
%%% digits after HE in the file name; if one digit HE (eg., 8) then it 
%%% should be written as 0X in the name of the file. You can have 1 to 4 
%%% digits for the HN names, but one digit for each name (ie., it means you 
%%% can have between 1 to 4 HN cells to analyze). File format: 
%%% at the beginning, optional 10 lines of strings, then data given per 
%%% columns as [time pre1 pre2 ... preN post].
%%%
%%% 2) Windows to allow user to remove spike traces from file; This can 
%%% be done in 2 ways: by removing a number of spikes from the 
%%% beginning/end of each burst of the signal, or by keeping a number of 
%%% spikes in a burst counting from its middle spike. In addition, user can
%%% manually remove those traces that she wishes, in a separate window.
%%%
%%% 3) After trace cleaning has been done: program plots in a window all 
%%% traces (in the chosen window) and their average with peak and lows 
%%% calculated by Mike's code; in a separate window this average is zoomed
%%% in. Then, program writes new data to a file. Once all signal data have
%%% been done, program writes all signals to new file (*_new*); this file 
%%% can be re-used again with the code (remove "_new" from its name).
%%% 


function startSpkTrigAvgAnalysis

% clear existing variables in the matlab workspace.
clear all;

% Step 1: What kind of file are you using? Some like to remove the header
% from the atf file manually (and may rename it a .dat file), but matlab is
% capable of ignoring the first number of lines in a text file that
% correspond to the header. if you are using an atf file WITHOUT a header,
% enter a 0, if you have an atf file WITH the header intact, enter 1
header = 1;

% assumes correct parsing of file name conform convention
[file_nameInp, origTraces, strOfTop10Lines] = ...
    getTraceToAnalyzeFromFile(header);

file_nameInp

% assumes correct parsing of file name conform convention
[namesHN, ~] = getHNnames(file_nameInp); % was heName
[~,c] = size(namesHN);

a = size(origTraces);
noChanels = a(1,2); 
clear a;

% select your signal; press 'Cancel' to quit program.
prompt = 'Enter name of HN signal: ';
for i = 1:c-1
    prompt = strcat(prompt,namesHN(1,i),', ');
end
prompt = strcat(prompt, namesHN(1,c));
%prompt = {'Enter name of HN signal: '};

name = 'Signal Input';
numlines = 1;
defaultanswer = {'3'};
answer = inputdlg(prompt,name,numlines,defaultanswer);
% disp(['Selected channel: ' num2str(answer)])
while ~isempty(answer) % quit program    
    %[val status] = answer{1} %str2num(answer{1})
    val = answer{1};
    ck = 0; % returns index of signal in namesHN, if signal is found
    for i = 1:c
       if strcmp(val, namesHN(1,i))
           ck = i;
           break;
       end
    end
    if ck > 0
        %disp(['here signal ' val ' at index ' num2str(ck)]);
        disp('***************************************************')
        disp(['******************* Channel #' namesHN{ck} ' ********************'])
        disp('***************************************************')
        %disp(['column traces: ' num2str(ck+1)])

        %%% logic: index ck in namesHN corresponds to (ck+1) signal in the
        %%% origTraces (because in the file time is on the first column) 
        data = [origTraces(:,1) origTraces(:,ck+1) origTraces(:,noChanels)];
        
        sta_5_master_sta(data, strOfTop10Lines, file_nameInp, ...
            namesHN{ck}); % starts analysis

        clear data;
    else
        h = errordlg(['Signal ' val ' not found'],'Signal Error');
        uiwait(h);
    end
    
    answer = inputdlg(prompt,name,numlines,defaultanswer);
end
  

 hclose = warndlg('Press ok to close all windows!!!');
 waitfor(hclose);
 close all;
 %clear all;
 
 %writeNewAllDataFile(file_nameInp, namesHN, origTraces, strOfTop10Lines);
 %writeAllDataToFileNewFormat(file_nameInp, namesHN, origTraces, strOfTop10Lines); 
 %%% tmp commented out to speed up the programming
 disp('..........DONE!!!...........')
 clear all;
end


%disp('uuuuuuuuu');
%return;

%  for i = 2:(noChanels - 1)
%      disp('***************************************************')
%      disp(['********** Channel #' namesHN{i-1} ' ********************'])
%      disp('***************************************************')
%      data = [origTraces(:,1) origTraces(:,i) origTraces(:,noChanels)];
%      
%      %sta_1_global
%      sta_5_master_sta(data, strOfTop10Lines, file_nameInp, namesHN{i-1}); % starts analysis
%      clear data;
%  end
 

% % idxCell = 3; %to be fixed later
% % data = [origTraces(:,1) origTraces(:,idxCell) origTraces(:,noChanels)];
% % 
% % %sta_1_global % global variables
% % sta_5_master_sta(data, strOfTop10Lines, idxCell, file_nameInp); % starts analysis according to user choices
