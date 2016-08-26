function newFileName = writeToFileNewTimes(fileName, namehn, origTimes, leftTimes)
        
[str1, str2] = strtok(fileName,'.');
newFileName = strcat(str1, '_', namehn, str2)        
   
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
matr = [origTimes auxTimes];

dlmwrite(newFileName, matr, '-append', 'delimiter' , '\t', ...
    'precision', '%.5f');

end


% fid = fopen(newFileName, 'w');
% for row=1:nrows
%     fprintf(fid, '%s', strTop{row,:});
% end
% fclose(fid);

