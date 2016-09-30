function printToFile_STDs(fileName, signalName, avgTr, stdTr, idxL, idxR, ...
                          amplL, amplR, ampLSTD, ampRSTD)

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
% But make it a Matlab .m script
newFileName = strcat(str1,'_',signalName,'_STD','.m');
dlmwrite(newFileName, 'avg_array = [', '-append','delimiter','');
%maty = mat2str(avgTrT);
dlmwrite(newFileName, av, '-append',  'precision', '%.10f');
dlmwrite(newFileName, '];', '-append','delimiter','');
dlmwrite(newFileName, 'std_array = [', '-append', 'delimiter','');
%matr = mat2str(stdT);
dlmwrite(newFileName, st, '-append',  'precision', '%.10f');
dlmwrite(newFileName, '];', '-append','delimiter','');
 
dlmwrite(newFileName, 'indexLeft = ...', '-append', 'delimiter',''); 
dlmwrite(newFileName, idxL, '-append');

dlmwrite(newFileName, 'idxRight = ...', '-append', 'delimiter',''); 
dlmwrite(newFileName, idxR, '-append');

dlmwrite(newFileName, 'maxSTD = ...', '-append', 'delimiter',''); 
%aa =  num2str(max(stdT));
dlmwrite(newFileName, max(st), '-append', 'precision', '%.10f');
dlmwrite(newFileName, 'minSTD = ...', '-append', 'delimiter',''); 
dlmwrite(newFileName, min(st), '-append', 'precision', '%.10f');

dlmwrite(newFileName, 'traces = ...', '-append',  'delimiter','');
dlmwrite(newFileName, traces, '-append');
%(idxXleft:idxXright,1)

% write the already calculated values for amp and STDs
dlmwrite(newFileName, [ 'amplL = ' num2str(amplL) ';' ], '-append',  'delimiter','');
dlmwrite(newFileName, [ 'amplR = ' num2str(amplR) ';' ], '-append',  'delimiter','');
dlmwrite(newFileName, [ 'ampLSTD = ' num2str(ampLSTD) ';' ], '-append',  'delimiter','');
dlmwrite(newFileName, [ 'ampRSTD = ' num2str(ampRSTD) ';' ], '-append',  'delimiter','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end