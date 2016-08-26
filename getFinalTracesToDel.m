function allTr = getFinalTracesToDel(trToDel, trToBulkRem, marked)
ss = length(trToDel);

for i = 1:ss    
    bx = trToDel{i};
    if (~isempty(bx))
        ax = trToBulkRem{i};
        cx = marked{i+1}; % this has also the ref burst
        ix = find(cx);
        bbx = bx + ix(1,1) - 1;
        aa = [ax; bbx];
        allTr{i} = sort(aa);
    else
        allTr{i} = trToBulkRem{i};
    end
    %allTr{i} = unique(bb);
   
end
end