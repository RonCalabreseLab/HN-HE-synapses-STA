function writeAllDataToFileNewFormat(file_nameIn, numHNs, origTr, top10Lines)
%filesATF = dir('HN*.atf') % refer to each with filesATF(1).name



%build up the new file name
[str1, str2] = strtok(file_nameIn,'.')
%[str1, str2] = strtok(filesATF(1).name,'.')
newFileName = strcat(str1,'_new',str2)

% read HN numbers
%hnNum = regexp(filesATF(1).name,'\d','match')
numHNs

%read header from initial file
%strTopFile = getTopFile(filesATF(1).name); %each cell is a line; reads top 10 lines
%strTopFile = getTopFile(file_nameIn);
top10Lines
lastLine = top10Lines{10}
timeStr = '"Time (s)"';
postStr = '"Post Trace (nA)"';
preStr = '"Trace #1 (uV)"';

% read in initial traces [time pre1 pre2 pre3 pre4 post]
%origData = textread(filesATF(1).name,'','headerlines',10);
[~, colOrig] = size(origTr);
flag = -1;
if (strfind(str1, '_new')) %orig file is in new format 
    % [time1 pre1 post1 time2 pre2 post2]
    numberOfPres = colOrig / 3
    numberColumsNewData = colOrig
    flag = 2;
else %orig file is in old format [time pre1 pre2 post]
    numberOfPres = colOrig - 2
    numberColumsNewData = 3 * numberOfPres
    flag = 1;
    aa = cell(1,numberColumsNewData);
    for i = 1:3:numberColumsNewData
        aa{i} = timeStr;
        aa{i+1} = preStr;
        aa{i+2} = postStr;
    end
    top10Lines{10} = aa;
end
%top10Lines
lastLine = top10Lines{10}

% cell to hold new data to write to file

newData = cell(1,numberColumsNewData);
%size(newData)

disp('...files that have the info data of the channels that had spikes removed...')
files = dir(strcat(str1,'_*.atf')) %get the files obtained from orig file


%%% fill newData with info data from pre files which have spikes removed
for i = 1:length(files)
    % read in file with pre
    str = files(i).name
    dashNum0 = str(strfind(str,'_') + 1); 
    dashNum = dashNum0(1, end)
    %size(dashNum)
    
    for j = 1: length(numHNs)-1
        %disp(['idx of pre = ' num2str(j)])
        preName = numHNs{j};
        if strcmp(preName, dashNum) %first file
            %read data from modif pre file
            preData = textread(str,'','headerlines',10); 

            idx = (j - 1) * 3 + 1;
            newData{idx} = preData(:,1);
            newData{idx + 1} = preData(:,2);
            newData{idx + 2} = preData(:,3);
            %preName
            
            disp(['Pre ' num2str(i) ' changed, is HN ' preName])
        end    
    end
end

%newData

%%% fill newData with info from unchaged pre channels
if (flag == 1) %orig file is in old format [time pre1 pre2 post]
    time = origTr(:,1);
    post = origTr(:,end);

    for j = 0:(numberOfPres - 1)
        %j
        idx = j * 3 + 1;
        %newData{idx}
        if(isempty(newData{idx}))
            %newData{idx} = origTr
            %disp(['empty at idx = ' num2str(idx)])
            newData{idx} = time;
            newData{idx+1} = origTr(:, j + 2);
            newData{idx+2} = post;
        end
    end
end
if (flag == 2) %orig file is in new format 
    % [time1 pre1 post1 time2 pre2 post2]
    for i = 1:colOrig
        if(isempty(newData{i}))
            newData{i} = origTr(:,i);
        end
    end
    
end

%newData
lenND = length(newData);

mmax = 0;
for i = 1: lenND
   if mmax < length(newData{i})
       mmax = length(newData{i});
   end
end
mmax


for i = 1:lenND
    dif = mmax - length(newData{i});
    if dif > 0
       aux = zeros(dif,1);
       vv = [newData{i};aux];
       newData{i} = vv;
    end
end
%newData

% write new data to file
[~, ncols] = size(top10Lines);
fid = fopen(newFileName, 'w');
for col = 1:ncols-1
    %top10Lines{:,col}
    fprintf(fid, '%s', top10Lines{:,col});
end
fclose(fid);

%%% function to convert the cell of strings (lastLine) into matrix of
%%% strings, which can be written to file
cvt_str = cellfun(@(x) sprintf('%s', x), lastLine, 'UniformOutput', false)
%%% or s = cell(); [s{:}] to cancatenate its cells of strings
%size(cvt_str)
dlmwrite(newFileName, cvt_str, '-append', 'delimiter' , '\t');

matr = cell2mat(newData);
dlmwrite(newFileName, matr, '-append', 'delimiter' , '\t', ...
     'precision', '%.5f');

end


%case of an empty pre
%  for i = 2:length(newData)-1 %check for missing pre and put in the orig data
%      if (isempty(newData{i}))
%          if (isempty(newData{1}))
%              newData{1} = origTr(:,1);
%              newData{end} = origTr(:,end);
%          end
%          newData{i} = origTr(:,i);
%      end
%  end
 
 %fill the time and post, if there was no empty pre
%  if (isempty(newData{1}))
%         newData{1} = vTimeMax;
%         newData{end} = vPostMax;
%  end
 
% disp(['time ' num2str(size(newData{1}))])
% disp(['pre1 ' num2str(size(newData{2}))])
% disp(['pre2 ' num2str(size(newData{3}))])
% disp(['pre3 ' num2str(size(newData{4}))])
% disp(['pre4 ' num2str(size(newData{5}))])
% disp(['post ' num2str(size(newData{6}))])

% disp(['time ' num2str(size(newData{1}))])
% disp(['pre1 ' num2str(size(newData{2}))])
% disp(['pre2 ' num2str(size(newData{3}))])
% disp(['pre3 ' num2str(size(newData{4}))])
% disp(['pre4 ' num2str(size(newData{5}))])
% disp(['post ' num2str(size(newData{6}))])
