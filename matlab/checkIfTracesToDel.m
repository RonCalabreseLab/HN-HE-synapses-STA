function boolCheck = checkIfTracesToDel(cellTr)

boolCheck = false; %default no trace to be removed

n = length(cellTr);

for i = 1:n
   if (~isempty(cellTr{1,n}))
       boolCheck = true;
       return
   end
end

end