function writeNewAllDataFile(file_nameIn, numHNs, origTr, top10Lines)
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

% read in initial traces [time pre1 pre2 pre3 pre4 post]
%origData = textread(filesATF(1).name,'','headerlines',10);
[rowOrig, colOrig] = size(origTr);

% cell to hold new data to write to file
newData = cell(1,colOrig);
size(newData)

files = dir(strcat(str1,'_*.atf')) %get the files obtained from orig file
vTimeMax = [];
vPostMax = [];
mmax = 0;
for i = 1:length(files)
    % read in file with pre
    str = files(i).name
    dashNum0 = str(strfind(str,'_') + 1); 
    dashNum = dashNum0(1, end)
    %size(dashNum)
    
    for j = 1: length(numHNs)-1
        %j
        preName = numHNs{j};
        if strcmp(preName, dashNum) %first file
            preData = textread(str,'','headerlines',10);
%             if length(preData(:,1)) > length(newData{1})
%                  newData{1} = preData(:,1); %time
%                  newData{end} = preData(:,3); %post
%             end
            newData{j+1} = preData(:,2);
            %preName
            size(newData{j+1})
            if (mmax < length(preData(:,2)))
                mmax = length(preData(:,2));
                vTimeMax = preData(:,1);
                vPostMax = preData(:,3);
            end
            disp(['Pre ' num2str(i) ' changed, is HN ' preName])
        end    
    end
end
  
%case of an empty pre
 for i = 2:length(newData)-1 %check for missing pre and put in the orig data
     if (isempty(newData{i}))
         if (isempty(newData{1}))
             newData{1} = origTr(:,1);
             newData{end} = origTr(:,end);
         end
         newData{i} = origTr(:,i);
     end
 end
 
 %fill the time and post, if there was no empty pre
 if (isempty(newData{1}))
        newData{1} = vTimeMax;
        newData{end} = vPostMax;
 end
 
% disp(['time ' num2str(size(newData{1}))])
% disp(['pre1 ' num2str(size(newData{2}))])
% disp(['pre2 ' num2str(size(newData{3}))])
% disp(['pre3 ' num2str(size(newData{4}))])
% disp(['pre4 ' num2str(size(newData{5}))])
% disp(['post ' num2str(size(newData{6}))])
mmax = max([length(newData{1}),length(newData{2}),length(newData{3}),...
    length(newData{4}),length(newData{5}),length(newData{6})]);
for i = 1:length(newData)
    dif = mmax - length(newData{i});
    if dif > 0
       aux = zeros(dif,1);
       vv = [newData{i};aux];
       newData{i} = vv;
    end
end
% disp(['time ' num2str(size(newData{1}))])
% disp(['pre1 ' num2str(size(newData{2}))])
% disp(['pre2 ' num2str(size(newData{3}))])
% disp(['pre3 ' num2str(size(newData{4}))])
% disp(['pre4 ' num2str(size(newData{5}))])
% disp(['post ' num2str(size(newData{6}))])

% write new data to file
[nrows,ncols]= size(top10Lines);
fid = fopen(newFileName, 'w');
for row=1:nrows
    fprintf(fid, '%s', top10Lines{row,:});
end
fclose(fid);

 matr = cell2mat(newData);
 dlmwrite(newFileName, matr, '-append', 'delimiter' , '\t', ...
     'precision', '%.5f');

end