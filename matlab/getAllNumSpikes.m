function nspk = getAllNumSpikes(postSpk)

nspk = 0;
for i = 1:length(postSpk)
    [row, col] = size(postSpk{i});
    nspk = nspk + col;
end

end