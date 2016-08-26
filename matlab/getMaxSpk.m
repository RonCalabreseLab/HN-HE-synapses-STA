function minNo = getMaxSpk(cellData) %should be min num
mins = zeros(1,length(cellData));

for i=1:length(cellData)
   [~,c] = size(cellData{i});
   mins(1,i) = c;
end
minNo = min(mins);
end