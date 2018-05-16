% Finding all the files in a certain directory
%
% House Keeping Commands
clear all
clc
close all
% Starts here
InstructorName = input('What instructor are these files for?', 's');
Directory = cd;
FolderIndex = regexp(cd,'\');
Folder = Directory(FolderIndex(end)+1:end);
SearchArea = sprintf('%s\\*\\**\\*.m',cd);
Files = rdir(SearchArea);
mkdir(Directory,'MFILES');
for ii = 1:length(Files)
    FileName = Files(ii).name;
    if regexp(FileName,'MACOS') >= 0
        Files(ii).name = 'REPEATEDFILE';
    else
        OriginalFileName = Files(ii).name;
        JustMFileName = regexp(OriginalFileName,'\');
        Cougarnet = regexp(OriginalFileName,'_');
        FileName = sprintf('%s%s\\MFILES\\%s_%0.0f_%s_%s.m',Directory(1:FolderIndex(end)),Folder,InstructorName,ii,OriginalFileName(JustMFileName(end)+1:end-2),OriginalFileName((Cougarnet(1) + 1):(Cougarnet(2) - 1)));
        FindDirectory = regexp(FileName, '\');
        movefile(OriginalFileName,FileName,'f')
    end
end
CorrectDirectory = sprintf('%s\\MFILES\\',cd);
Files = rdir(CorrectDirectory);
Directory2 = cd(CorrectDirectory);