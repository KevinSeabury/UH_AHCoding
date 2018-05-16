% Data Analysis Version 1.7
% Updated November 13,2017

clear 
clc
close all

% Load in the completed variable mat file
% inputting assignment title
AssignName = input('Please input assignment name','s');
NameString = sprintf('%s_RESULTS.txt',AssignName);
load('ALLDATA.mat')
diary(NameString)
% Renaming Variables
TotalLines1 = TotalLines;
Similar = MatchingLines;
% Finding average and standard deviation for each matrix.
SDT = std(TotalLines1(TotalLines1>0));
AvgT = mean(TotalLines1(TotalLines1>0));
SDS = std(Similar(Similar>0));
AvgS = mean(Similar(Similar>0));
% Pre-allocating matrix dimensions to increase performance for large sets
% of data.
FlaggedFiles = zeros(L,L);
input1 = 1.25;
input2 = 4;
input3 = 1;
[getridrow, getridcol] = find(TotalLines1>(AvgT + input2*SDT));
[getridrow1, getridcol1] = find(TotalLines1<(AvgT - input3*SDT));
for pp = 1:length(getridrow)
    TotalLines1(getridcol(pp)) = 0;
end
for kk = 1:length(getridrow1)
    Similar(getridcol1,:) = 0;
end
SDT = std(TotalLines1(TotalLines1>0));
AvgT = mean(TotalLines1(TotalLines1>0));
for aa = 1:length(Similar)
    if Similar(aa,:) == 0
        MAXS(aa) = 0;
    else
        MAXS(aa) = max(Similar(aa,:));
    end
end
SDS = std(MAXS);
AvgS = mean(MAXS);
% IMPORTANT IF YOU WOULD LIKE TO USE OWN SETTINGS AND NOT DEFAULT,
% UNCOMMENT INPUT LINES!!!!!
% input1 = input('\nHow many standard deviations does a student have to be above the similar lines mean to be flagged for similar work?');
% input2 = input('\nHow many standard deviations above average length does the students file have to be to not be considered?');
% input3 = input('How many standard deviations below the mean does the student have to be in terms of m-file length to not be considered for flagging?');
% Removing files that are way to long, that are messing with my standard
% deviation.  Will have to find a better fix for this later as this removes
% extremely long files from being considered in the analysis.
for cc = 1:L
    for dd = cc+1:L
        if Similar(cc,dd) >= AvgS + input1*SDS
            FlaggedFiles(cc,dd) = 1.5;
        end
        if dd == L & TotalLines1(cc) <= AvgT - input3*SDT
            FlaggedFiles(cc,:) = 0;
        end
    end
end
% Finds the correspond indexs of people that were flagged so that we can
% extract file-names + similarity and differences in lines and output to
% screen.
[rowFF, colFF] = find(FlaggedFiles>0);
FF = [rowFF, colFF];
StringStudent = {};
fprintf('\n----------UNIQUE SETS NEEDED FOR REVIEW----------\n')
for ee = 1:length(FF(:,1))
    Student1 = FF(ee,1);
    Student2 = FF(ee,2);
    StringStudent{ee,1} = files(Student1).name;
    StringStudent{ee,2} = files(Student2).name;
    fprintf('SET %1.0f\t\t%2.1f %% SIMILAR',ee,100*Similar(Student1,Student2))
    fprintf('\n%s\tTL = %0.0f  \n\t&&\t\t\n%s\tTL = %0.0f\n',StringStudent{ee,1},TotalLines(FF(ee,1)),StringStudent{ee,2},TotalLines(FF(ee,2)))
end
fprintf('\n----------UNIQUE FILES NEEDED FOR REVIEW---------- \n')
for ff = 1:length(unique(FF(:)))
    MFilesNeeded = unique(FF(:));
    Student1 = MFilesNeeded(ff);
    StringStudent1 = files(Student1).name;
    fprintf('%1.0f.  %s  \n\n',ff,StringStudent1)
end
diary off
save('ForInstructorReview.mat','StringStudent','Similar','FlaggedFiles','Statement','Statement1')

