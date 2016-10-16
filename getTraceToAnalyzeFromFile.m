% file syntax: time trace1 trace2 trace3 trace4 tracePost
function [fileName, origData, strTopFile] = ...
      getTraceToAnalyzeFromFile(headerHere, filePattern, selectMessage)

fileName = uigetfile(filePattern, selectMessage);
origData = [];
strTopFile = [];

if headerHere == 0
     origData = load(fileName); %put in file extension .dat or .atf.     
else if headerHere == 1
          %fileName = uigetfile('*.atf','Please select your .atf file');
          %put in file extension .dat or .atf.
          strTopFile = getTopFile(fileName); %each cell is a line
          origData = textread(fileName,'','headerlines',10);           
     end
end

