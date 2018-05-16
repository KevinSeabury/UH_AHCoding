% Selector Version 1.0
% created by Kevin Seabury
% January 23, 2017
% Spring 2017 ENGI 1331 

% House keeping commands
clear all
clc
close all
% This m-file will be used to move/copy flagged m-files for further review.
% Ideally it should bring both files onto your screen as new windows and
% ask you if you would like to consider a set of files an academic honesty
% violation.

load('ForInstructorReview.mat');
load('ALLDATA.mat','files');
Location = uigetdir(matlabroot,'MATLAB Root Directory');
AssignName = input('Please input assignment name','s');
NameString = sprintf('%s_VIOLATIONS.txt',AssignName);
% First let us move all the files 
AllFiles = unique(StringStudent);
for ii = 1:length(AllFiles)
    FileLocation{ii} = sprintf('%s//%s',Location,AllFiles{ii});
    NewFileLocation{ii} = sprintf('FLAGGEDFILES//%s',AllFiles{ii});
    copyfile(FileLocation{ii},NewFileLocation{ii})
end

for ii = 1:length(StringStudent)
    FileOneLocation{ii} = sprintf('FLAGGEDFILES//%s',StringStudent{ii,1});
    FileTwoLocation{ii} = sprintf('FLAGGEDFILES//%s',StringStudent{ii,2});
    FileOneIndex = regexp(FileOneLocation{ii},{'\', '/'});
    FileTwoIndex = regexp(FileTwoLocation{ii},{'\', '/'});
    open(FileOneLocation{ii})
    open(FileTwoLocation{ii})
    FlagStatus(ii) = menu('Should this file set be pursued for an academic honesty violation?', 'YES' , 'NO');
    Windows = matlab.desktop.editor.getAll;
    for jj = 1:length(Windows)
        CurrentWindow = Windows(jj).Filename;
        FNL = regexp(CurrentWindow,{'\', '/'});
        FNL = cell2mat(FNL);
        CurrentWindow = CurrentWindow(FNL(end)+1:end);
        if strcmp(CurrentWindow,StringStudent{ii,1})
            Windows(jj).close
        elseif strcmp(CurrentWindow,StringStudent{ii,2})
            Windows(jj).close
        end
    end
end
% Now to display the students flagged for academic honesty violations.
[rowFF, colFF] = find(FlaggedFiles>0);
FF = [rowFF, colFF];
Violations = find(FlagStatus==1);
save('ForFigures.mat','FlagStatus')
diary(NameString)
fprintf('\n----------UNIQUE SETS FLAGGED FOR ACADEMIC HONESTY VIOLATIONS----------\n')
for qq = 1:length(Violations)
    Student1 = FF(Violations(qq),1);
    Student2 = FF(Violations(qq),2);
    Student1Name = StringStudent{Violations(qq),1};
    Student2Name = StringStudent{Violations(qq),2};
    fprintf('SET %1.0f\t\t%2.1f %% SIMILAR,%2.1f %% DIFFERENT \n',qq,100*Similar(Student1,Student2),100*Difference(Student1,Student2))
    fprintf('\n%s  \n\t&&\t\t\n%s\n',Student1Name,Student2Name)
end
fprintf('\n \t----------UNIQUE FILES FLAGGED FOR ACADEMIC HONESTY VIOLATIONS---------- \n')
for ff = 1:length(unique(FF(Violations,:)))
    MFilesNeeded = unique(FF(Violations,:));
    Student1 = MFilesNeeded(ff);
    StringStudent1 = files(Student1).name;
    fprintf('%1.0f.  %s  \n\n',ff,StringStudent1)
end
diary off

