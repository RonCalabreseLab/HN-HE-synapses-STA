function strTopFile = getTopFile(fileName)

%this is slow bc reads the whole file
% txt =  textread(fileName, '%s', 'delimiter','\n');%fileread(fileName);
% size(txt)    
% 
% strTopFile = txt(1:10,1)
% clear txt;

%this reads only the first 10 lines of the file
strTopFile = [];
fid = fopen(fileName);
  for i = 1:10
   strTopFile{i} = fgets(fid);
  end
fclose(fid);

end