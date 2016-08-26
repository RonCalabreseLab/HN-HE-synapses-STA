function writeToFileNewData(fileName, namehn, strTop, time, pre, post)
[str1, str2] = strtok(fileName,'.');
newFileName = strcat(str1, '_', namehn, str2)  

[nrows,ncols]= size(strTop);
fid = fopen(newFileName, 'w');
for row=1:nrows
    fprintf(fid, '%s', strTop{row,:});
end
fclose(fid);

matr = [time pre post];
dlmwrite(newFileName, matr, '-append', 'delimiter' , '\t', ...
    'precision', '%.5f');

end