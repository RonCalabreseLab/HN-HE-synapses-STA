function printToFile_STDs(fileName, signalName, avgTr, stdTr, idxL, idxR)

k = 1;
traces = idxR - idxL + 1;
av = zeros(traces,1);
st = zeros(traces,1);
for ii=idxL:idxR 
    av(k) = avgTr(ii); 
    st(k) = stdTr(ii);
    k = k + 1; 
end


%%% write avg and sts in the file
format long g
%build up the new file name
[str1, str2] = strtok(fileName,'.');
newFileName = strcat(str1,'_',signalName,'_STD',str2);
dlmwrite(newFileName, 'avg = [', '-append','delimiter','');
%maty = mat2str(avgTrT);
dlmwrite(newFileName, av, '-append',  'precision', '%.10f');
dlmwrite(newFileName, '];', '-append','delimiter','');
dlmwrite(newFileName, 'std = [', '-append', 'delimiter','');
%matr = mat2str(stdT);
dlmwrite(newFileName, st, '-append',  'precision', '%.10f');
dlmwrite(newFileName, '];', '-append','delimiter','');
 
dlmwrite(newFileName, 'indexLeft = ', '-append', 'delimiter',''); 
dlmwrite(newFileName, idxL, '-append');

dlmwrite(newFileName, 'idxRight = ', '-append', 'delimiter',''); 
dlmwrite(newFileName, idxR, '-append');

dlmwrite(newFileName, 'maxSTD = ', '-append', 'delimiter',''); 
%aa =  num2str(max(stdT));
dlmwrite(newFileName, max(st), '-append', 'precision', '%.10f');
dlmwrite(newFileName, 'minSTD = ', '-append', 'delimiter',''); 
dlmwrite(newFileName, min(st), '-append', 'precision', '%.10f');

dlmwrite(newFileName, 'traces = ', '-append',  'delimiter','');
dlmwrite(newFileName, traces, '-append');
%(idxXleft:idxXright,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end