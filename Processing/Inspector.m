% Because the workload can not simply be done by cutting the total number
% of files by four.  We must use this function to cut the actual
% computational workload in four.

% House Keeping Commands
clear
clc
close all
% Get user to choose how many cores they would like to use to analyze the
% files
[core_info, NumCores] = evalc('feature(''numcores'')');
Question1 = sprintf('MATLAB has detected you can use up to %0.0f logical cores',NumCores);
fprintf('%s',Question1)
% Ask the user how many cores they would like to use
Cores = input('\nHow many cores would you like to use?');
while Cores < 1 || Cores > NumCores
    Cores = input('You entered in an illogical number of cores, please enter in how many cores you would like to use');
end
% Choosing Location
Location = uigetdir(matlabroot,'MATLAB Root Directory');
tic
FullPath = sprintf('%s\\*.m',Location);
files = dir(FullPath);
indexs = [];
for ii = 1:length(files)
    if files(ii).isdir == 0
        indexs = [indexs,ii];
    end
end
files = files(indexs);
L = length(files);
A(1) = L;
for ii = 2:L
    A(ii) = L - ii;
end
for jj = 1:L
    TheSum(jj) = sum(A(1:jj));
end
TheSum = TheSum / TheSum(end);
% Make the Inspector Function flexible for any positive integer number of
% cores.
CC(1) = 1;
ComputationsPerCore = 1 / Cores;
% Due to the way MATLAB starts batch processes, we need to balance out the
% workload for each CORE.
for ii = 1:Cores-1
    IndexChecker = find(TheSum>ComputationsPerCore);
    CC(2*ii) = IndexChecker(1);
    CC(2*ii+1) = CC(2*ii) + 1;
    ComputationsPerCore = ((ii+1) / Cores);
end
CC(2*Cores) = L;
for ii = 1:L
    FILERAW = sprintf('%s\\%s',FullPath(1:end-3),files(ii).name);
    [FileTEXT{ii},TotalLines(ii)]= FileReader(FILERAW);
end
TheRealTime = clock;
if TheRealTime(2) == 1
    Month = 'January';
elseif TheRealTime(2) == 2
    Month = 'Feburary';
elseif TheRealTime(2) == 3
    Month = 'March';
elseif TheRealTime(2) == 4
    Month = 'April';
elseif TheRealTime(2) == 5
    Month = 'May';
elseif TheRealTime(2) == 6
    Month = 'June';
elseif TheRealTime(2) == 7
    Month = 'July';
elseif TheRealTime(2) == 8
    Month = 'August';
elseif TheRealTime(2) == 9
    Month = 'September';
elseif TheRealTime(2) == 10
    Month = 'October';
elseif TheRealTime(2) == 11
    Month = 'November';
else
    Month = 'December';
end
Statement = sprintf('Inspector started %s %2.0f, %4.0f %2.0f:%2.0f:%2.0f\n',Month,TheRealTime(3),TheRealTime(1),TheRealTime(4),TheRealTime(5),TheRealTime(6));
X = L;
ComputingConstant = .0058901;  % When utilizing MATLAB 2017b on i5-3570k at 4.4GHz
EstimatedRunTime = ((ComputingConstant*X*(X-1)) / 2)/4; %in seconds
EstimatedRunTimeinMinutes = floor(EstimatedRunTime / 60);
EstimatedRunTimeInHours = floor(EstimatedRunTime / (60*60));
EstimatedRunTimeinDays = floor(EstimatedRunTimeInHours / 24);
% saves a text file named MA5Results in your current directory that stores
% all information in the command window as a text file.  NOTE: Running this
% file more than once will not overwrite this results entry and instead
% will just continue on the next new line. If you would like to generate a
% new file every single time you will have to manually change this line.
fprintf('Analyzing %1.0f m-files\n',L)
if EstimatedRunTime < 60
    TheEstimatedTime = sprintf('Estimated Run Time is %1.0f seconds\n',EstimatedRunTime);
elseif EstimatedRunTime < 60*60
    EstimatedRunTime1 = EstimatedRunTime - 60*EstimatedRunTimeinMinutes;
    TheEstimatedTime = sprintf('Estimated Run Time is %1.0f minutes %1.0f seconds\n',EstimatedRunTimeinMinutes, EstimatedRunTime1);
elseif EstimatedRunTime < 60*60*24
    EstimatedRunTime1 = EstimatedRunTime - 60*EstimatedRunTimeinMinutes;
    EstimatedRunTimeinMinutes1 = EstimatedRunTimeinMinutes - 60*EstimatedRunTimeInHours;
    TheEstimatedTime = sprintf('Estimated Run Time is %1.0f hours %1.0f minutes and %1.0f seconds\n',EstimatedRunTimeInHours,EstimatedRunTimeinMinutes1, EstimatedRunTime1);
elseif EstimatedRunTime < 60*60*24*7
    EstimatedRunTime1 = EstimatedRunTime - 60*EstimatedRunTimeinMinutes;
    EstimatedRuntimeinMinutes1 = EstimatedRunTimeinMinutes - 60*EstimatedRunTimeInHours;
    EstimatedRuntimeinHours1 = EstimatedRunTimeInHours - 24*EstimatedRunTimeinDays;
    TheEstimatedTime = sprintf('Estimated Run Time is %1.0f days %1.0f hours %1.0f minutes and %1.0f seconds\n',EstimatedRunTimeinDays,EstimatedRuntimeinHours1,EstimatedRuntimeinMinutes1, EstimatedRunTime1);
else
    TheEstimatedTime = sprintf('Estimated Run Time is more than one week, good luck fam.');
end
fprintf('%s',Statement)
fprintf('%s',TheEstimatedTime)
% Save information to Masterfile to distribute to different script files
% and computational cores.
save('MasterFile.mat')
batch('InspectorV20V1','Profile','local');
batch('InspectorV20V2','Profile','local');
batch('InspectorV20V3','Profile','local');
batch('InspectorV20V4','Profile','local');
% This constantly searches for the other mat files so that it can start the
% next stage of the analysis process the second all analysis in this stage
% is done.
Q = 0;
counter = 1;
Files = 0;
while length(Files) < 5
    Files = dir('*.mat');
end
pause(.1)
Time1 = toc;
TheRealTime1 = clock;
if TheRealTime1(2) == 1
    Month = 'January';
elseif TheRealTime1(2) == 2
    Month = 'Feburary';
elseif TheRealTime1(2) == 3
    Month = 'March';
elseif TheRealTime1(2) == 4
    Month = 'April';
elseif TheRealTime1(2) == 5
    Month = 'May';
elseif TheRealTime1(2) == 6
    Month = 'June';
elseif TheRealTime1(2) == 7
    Month = 'July';
elseif TheRealTime1(2) == 8
    Month = 'August';
elseif TheRealTime1(2) == 9
    Month = 'September';
elseif TheRealTime1(2) == 10
    Month = 'October';
elseif TheRealTime1(2) == 11
    Month = 'November';
else
    Month = 'December';
end
Statement1 = sprintf('Inspector ended   %s %2.0f, %4.0f %2.0f:%2.0f:%2.0f\n',Month,TheRealTime1(3),TheRealTime1(1),TheRealTime1(4),TheRealTime1(5),TheRealTime1(6));
fprintf('%s',Statement1)
TimeInMinutes = floor(Time1 / 60);
TimeinHours = floor(Time1 / (60*60));
TimeinDays = floor(Time1 / (60*60*24));
if Time1 < 60
    fprintf('Actual Run Time is %0.1f seconds\n',Time1)
elseif Time1 < 60*60
    Time = Time1 - 60*TimeInMinutes;
    fprintf('Actual Run Time is %1.0f minutes %1.0f seconds\n',TimeInMinutes, Time)
elseif Time1 < 60*60*24
    TimeinMinutes1 = TimeInMinutes - 60*TimeinHours;
    Time = Time1 - 60*TimeInMinutes;
    fprintf('Actual Run Time is %1.0f hours %1.0f minutes and %1.0f seconds\n',TimeinHours,TimeinMinutes1, Time)
elseif Time1 < 60*60*24*7
    TimeinHours1 = TimeinHours - 24*TimeinDays;
    TimeinMinutes1 = TimeInMinutes - 60*TimeinHours;
    Time = Time1 - 60*TimeInMinutes;
    fprintf('Actual Run Time is %1.f days %1.0f hours %1.0f minutes and %1.0f seconds\n',TimeinDays,TimeinHours1,TimeinMinutes1, Time)
else
    fprintf('Actual Run Time is more than one week, good luck fam.')
end
% Load all the Core.mat files to get the individual core run times
for ii = 1:Cores
    LoadString = sprintf('CORE%0.0f.mat',ii);
    load(LoadString)
end
save('MasterFile.mat','L','files','Statement','Statement1','Core1Time','Core2Time','Core3Time','Core4Time','Cores','CC')
% Build the ALLDATA.mat file
Similar = zeros(L,L);
% Endpoints, setting them here to make it easier to change for later
% rebuilds or mat files.
count = 0;
for ii = 1:2:2*Cores
    count = count + 1;
    MATString = sprintf('CORE%0.0f.mat',count);
    load(MATString)
    MatchingLines(CC(ii):CC(ii+1),:) = Similar(CC(ii):CC(ii+1),:);
end
% They are now all combined.

save('ALLDATA.mat','MatchingLines','TotalLines','L','files','Statement','Statement1')