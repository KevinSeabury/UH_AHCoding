function [rawtext linecount] = FileReader(FileName)
% Most of this code is adapted from Mathias Benedek's mfilecompare
% Which can be found at https://www.mathworks.com/matlabcentral/fileexchange/29781-mfilecompare?s_tid=gn_loc_drop
fid = fopen(FileName);
rawtext = '';
tline = '';
linecount = 0;
while 1
    tline = fgets(fid);
    
    if ~ischar(tline)
        break
    end
    tline = strtrim(tline);
    if ~isempty(tline)
        linecount = linecount+1;
        rawtext = [rawtext, tline, char(13)];
    end
end
fclose(fid);
end




