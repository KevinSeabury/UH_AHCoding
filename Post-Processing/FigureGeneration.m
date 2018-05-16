% Testing stuff for figure generation
% House keeping commands
clear all
clc
close all
% Now to get the mean and standard deviations
load('ForInstructorReview.mat')
load('ForFigures.mat')
SDS = std(Similar(Similar>0));
AvgS = mean(Similar(Similar>0));
SDD = std(Difference(Difference>0));
AvgD = mean(Difference(Difference>0));

for ii = 1:100
    Similar1 = Similar(Similar>(ii-1)/100 & Similar<=ii/100);
    Difference1 = Difference(Difference>(ii-1)/100 & Difference<=ii/100);
    S(ii) = length(Similar1);
    D(ii) = length(Difference1);
end

% 100*Similar(Student1,Student2),100*Difference(Student1,Student2))
% this code will be useful later on
[rowFF, colFF] = find(FlaggedFiles>0);
FF = [rowFF, colFF];
Violations = find(FlagStatus==1);
LocationFigures = uigetdir(matlabroot,'PLEASE CHOOSE WHERE YOU WANT THE FIGURES TO BE SAVED');
% Calculate standard deviations
SDS1 = AvgS + SDS;
SDS2 = AvgS + 2*SDS;
SDS3 = AvgS + 3*SDS;
X0 = 100*[AvgS,AvgS];
X1 = 100*[SDS1,SDS1];
X2 = 100*[SDS2,SDS2];
X3 = 100*[SDS3,SDS3];
YMax = max(S) + .025*max(S);
YMAX = [0,YMax];
for ee = 1:length(Violations)
Student1 = FF(ee,1);
Student2 = FF(ee,2);
X = 1:100;
figure(ee)
YMax = max(S) + .025*max(S);
hold
plot(X,S,X0,YMAX,X1,YMAX,X2,YMAX,X3,YMAX)
SValue = ceil(100*Similar(Student1,Student2));
h = plot(SValue,S(SValue),'o','MarkerSize',10);
set(h(1),'MarkerEdgeColor','none','MarkerFaceColor','r')
xlabel('Percent Similarity')
ylabel('Frequency of Occurences')
TitleName = sprintf('SET %1.0f SIMILARITY INFORMATION',ee);
title(TitleName)
axis([0 100 0 YMax])
legend('1 SD','2 SD','3 SD','4 SD','FlagPoint');
FileName = sprintf('%s\\SET%1.0fSimilarity.jpeg',LocationFigures,ee);
saveas(ee,FileName)
close(ee)
end
