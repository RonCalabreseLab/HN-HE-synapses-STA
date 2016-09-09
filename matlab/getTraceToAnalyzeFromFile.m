% Step 1: What kind of file are you using? Some like to remove the header
% from the atf file manually (and may rename it a .dat file), but matlab is
% capable of ignoring the first number of lines in a text file that
% correspond to the header. if you are using an atf file WITHOUT a header,
% enter a 0, if you have an atf file WITH the header intact, enter 1
%
% file syntax: time trace1 trace2 trace3 trace4 tracePost
function [fileName, origData, strTopFile] = getTraceToAnalyzeFromFile(headerHere)

[fileName, pathname] = uigetfile('*.atf','Please select your .atf file');
origData = [];
strTopFile = [];

% Use full path to address file
fileName = [pathname filesep fileName];

if headerHere == 0
     origData = load(fileName); %put in file extension .dat or .atf.     
else if headerHere == 1
          %fileName = uigetfile('*.atf','Please select your .atf file');
          %put in file extension .dat or .atf.
          strTopFile = getTopFile(fileName); %each cell is a line
          origData = textread(fileName,'','headerlines',10);           
     end
end

