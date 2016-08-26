function allTr = getFinalTracesToDel_1(trToDel, trToBulkRem, noSpkLBulk)
ss = length(trToDel);

for i = 1:ss
   ax = trToBulkRem{i};
   bx = trToDel{i};
   bbx = bx + noSpkLBulk;     
   aa = [ax; bbx];
   allTr{i} = sort(aa);
   %allTr{i} = unique(bb);
   
end
end