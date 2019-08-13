function PresentTotalTimeOfTwoMiceInteraction(HandlesForGUIControls,StartingFrameForAnalysisNum,LastFrameAnalyzed,TimesOfTwoMiceInteraction); 
%PRESENTTOTALTIMEINCOMPARTMENTS Summary of this function goes here
%   Detailed explanation goes here
TotalTimeOfTwoMiceInteraction=length(TimesOfTwoMiceInteraction);
axes(HandlesForGUIControls.axes1);
cla reset;
set(HandlesForGUIControls.axes1,'box','on','Visible','on')
hold on;

TotalTimeOfNoInteraction=LastFrameAnalyzed-StartingFrameForAnalysisNum-TotalTimeOfTwoMiceInteraction;
bar(1:2,[TotalTimeOfTwoMiceInteraction TotalTimeOfNoInteraction])
xlim([0 3]);
ylim([0 max([TotalTimeOfTwoMiceInteraction TotalTimeOfNoInteraction])+50]);
set(gca,'XTick',0:1:3)
set(gca,'XTickLabel',{'','Interaction','No Interaction'})
xlabel('Two mice interaction');
ylabel('Total number of frames')
hold off;

end

