% Inspector File Version 2.0
% Last Updated October 20,2017
% Computational Core 2
clear
clc;
close 
tic
% Load Configuration Settings from 'CriticalPointFinder.m'
load('MasterFile.mat','CC','files','L','FullPath','TotalLines','FileTEXT')
RR = CC(3);
QQ = CC(4);

% Initializes matrices to improve code performance.
Similar = zeros(QQ,L);
% Finds Similarity for Files between indexs RR and QQ
for bb = RR:QQ
    for aa = bb+1:L
        Similar(bb,aa) = textcompare(FileTEXT{bb},FileTEXT{aa},8);    
    end
end
% Just to make the command window look nice :D
CurrentDirectory = cd;
% SAVING IMPORTANT THINGS TO MAT FILE
ProperDirectory = regexp(CurrentDirectory,'\');
FolderName = CurrentDirectory(ProperDirectory(end)+1:end);
Directory = sprintf('%sALLFILES\\CORE2.mat',CurrentDirectory(1:ProperDirectory(end)));
Core2Time = toc;
save(Directory,'Similar','Core2Time');
quit