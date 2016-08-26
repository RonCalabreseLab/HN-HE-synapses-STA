function winFr = getAvgSpkUsed(wnt, postSpkTr)

len = length(wnt);
win = zeros(len,1);
winFr = zeros(len,1);

for i=1:length(postSpkTr)
   %[r,c] = size(postSpkTr{i});
   win = win + sum(postSpkTr{i},2);
end

winFr = (win ./ len);
end