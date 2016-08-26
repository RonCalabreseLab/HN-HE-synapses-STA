function [timeLeft, preLeft, postLeft] = getLeftData(data, idxRemSpikes)

len = length(data(:,1));% - length(idxRemSpikes)
% auxT = zeros(len,1);
% auxPre = zeros(len,1);
% auxPost = zeros(len,1);

auxT = data(:,1);
auxPre = data(:,2);
auxPost = data(:,3);

%idxRemSpikes

for i = 1:length(idxRemSpikes)
    %idxRemSpikes(i,1)
    auxT(idxRemSpikes(i,1),1) = 0;
    auxPre(idxRemSpikes(i,1),1) = 0;
    auxPost(idxRemSpikes(i,1),1) = 0;
end

disp('...........in getLeftData............')
aux = find(auxT > 0);
for k = 1:length(aux)
    %k
    timeLeft(k,1) = auxT(aux(k,1),1);
    preLeft(k,1) = auxPre(aux(k,1),1);
    postLeft(k,1) = auxPost(aux(k,1),1);
end
% sTime = length(timeLeft)
% sPre = length(preLeft)
% sPost = length(postLeft)

end


% timeV = data(:,1);
% preV = data(:,2);
% postV = data(:,3);
% 
% lenIdx = length(idxRemSpikes)
% 
% for i = 1:len
%     auxT(i,1) = timeV(i,1);
%     for j = 1:lenIdx
%         
%     end
% end

%%% this way cannot be used bc some voltages are 0
% auxT = data(:,1);
% auxPre = data(:,2);
% auxPost = data(:,3);
% 
% %idxRemSpikes
% 
% for i = 1:length(idxRemSpikes)
%     %idxRemSpikes(i,1)
%     auxT(idxRemSpikes(i,1),1) = 0;
%     auxPre(idxRemSpikes(i,1),1) = 0;
%     auxPost(idxRemSpikes(i,1),1) = 0;
% end
% 
% timeLeft = auxT(find(auxT > 0));
% sTime = length(timeLeft)
% preLeft = auxPre(find(auxPre > 0));
% sPre = length(preLeft)
% postLeft = auxPost(find(auxPost > 0));
% sPost = length(postLeft)