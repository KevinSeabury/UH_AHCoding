% Comment Stripper
% The following file was made by, Peter J Acklam
% Documentation for this file/s can be found at
% http://www.mathworks.com/matlabcentral/fileexchange/4645---matlab-comment-stripping-toolbox
Location = uigetdir(matlabroot,'MATLAB Root Directory');
% You must enter the MA name in the format MA1,MA2 etc otherwise the script
% will error.
MANumber = input('Please input the MA name in the format MA#','s');

% Testing on the TestingThings.m file
FullPath = sprintf('%s\\*.m',Location);
files = dir(FullPath);

for pp = 1:length(files)
    FILENAME = sprintf('%s\\%s',Location,files(pp).name);
    
    A = fileread(FILENAME);
    fid = fopen(FILENAME);
    text = fread(fid, inf, '*char')';
    fclose(fid);
    while 1
        
        B = regexp(text,'%{');
        C = regexp(text,'%}');
        if length(B) >= 1 & length(C) >=1
        text(B(1):C(1)+1) = [];
        else
            break
        end
    end
    fid = fopen(FILENAME, 'w');
fwrite(fid, text);
fclose(fid);
end

for pp = 1:length(files)
    FILENAME = sprintf('%s\\%s',Location,files(pp).name);
    B = find(FILENAME == '\');
    NEWFILENAME = sprintf('%s\\%sWOC\\%s',FILENAME(1:B(end-1)-1),MANumber,files(pp).name);
    mlstripcommentsfile(FILENAME,NEWFILENAME)
end