% file syntax: time trace1 trace2 trace3 trace4 tracePost
function [fileName, origData] = getDataAfterPreviousTraceRemovalFromFile()

fileName = uigetfile('*.atf','Please select your .atf file');
origData = load(fileName); %put in file extension .dat or .atf.     
[ro,co] = size(origData)

%%% process it???

end

