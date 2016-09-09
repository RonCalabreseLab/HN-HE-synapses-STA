function [hnNames, heName] = getHNnames(filename)

  [pathstr, filename, ext] = fileparts(filename);
  str = strtok(filename,'_');
str1 = strtok(str,'HE');
str2 = strrep(str, str1, 'HE');
hnNames = regexp(str1,'\d','match')
hes = regexp(str2,'\d','match');

heName = 0;
if strcmp(hes(1),'0')
    heName = hes(2) %str2num(hes(1,2))
else
    heName = str2num(hes{1}) * 10 + str2num(hes{2}) 
end


end

% flag = -1;
% if(strfind(filename,'new') > 0)
%     flag = 1; %%% new format [time pre post time pre post]
% else 
%     flag = 0; %%% initial format [time pre pre post]
% end
