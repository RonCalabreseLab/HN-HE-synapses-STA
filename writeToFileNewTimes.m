function newFileName = writeToFileNewTimes(fileName, namehn, origTimes, leftTimes)
 
% get file name base and extension
[str1, str2] = strtok(fileName,'.');

% add date/time stamp
newFileName = strcat(str1, '_', namehn, '_', ...
                     datestr(now, 'yyyy-mm-dd_HH:MM'), '.dat')        
   
% origTimes
% leftTimes
len = length(origTimes);
lenL = length(leftTimes);
auxTimes = zeros(len, 1);

for i = 1:len
   for j = 1:lenL
      if (origTimes(i,1) == leftTimes(j,1))
          auxTimes(i,1) = 1;
          break;
      end
      if (origTimes(i,1) < leftTimes(j,1))
          break;
      end
   end
end

%mat = [origTimes auxTimes leftTimes]
%leftTimes'

% add indices to end to make finding spikes easier next time
matr = [origTimes(:, 1) auxTimes origTimes(:, 3)];

% write 6 digit into file to be consistent with input precision
% CG: removed '-append' so that file contains only one set of removed spike data
dlmwrite(newFileName, matr, 'delimiter' , '\t', 'precision', '%.6f');

end


% fid = fopen(newFileName, 'w');
% for row=1:nrows
%     fprintf(fid, '%s', strTop{row,:});
% end
% fclose(fid);

